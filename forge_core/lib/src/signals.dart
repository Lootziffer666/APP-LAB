/// P2 — Signals: pure functions `attrs -> urgency in [0,1]`.
/// New signals register here; nothing else changes. This is the extension point.

import 'dart:math' as math;

const int kDayMs = 86400000;

double _clamp(double x, [double lo = 0, double hi = 1]) =>
    x < lo ? lo : (x > hi ? hi : x);

double? _num(Object? v) => v == null ? null : (v as num).toDouble();
int? _int(Object? v) => v == null ? null : (v as num).toInt();

/// A signal: looks at raw attrs at time [now] (epoch millis), returns urgency.
typedef Signal = double Function(Map<String, Object?> attrs, int now);

/// TIME: from an absolute dueDate AND/OR an interval since lastDone.
double timeSignal(Map<String, Object?> a, int now) {
  double t = 0;
  final due = _int(a['dueDate']);
  if (due != null) {
    final win = _num(a['warnDays']) ?? 30;
    final daysLeft = (due - now) / kDayMs;
    t = _clamp(1 - daysLeft / win);
    if (daysLeft < 0) t = 1;
  }
  final interval = _num(a['intervalDays']);
  final lastDone = _int(a['lastDone']);
  if (interval != null && lastDone != null && interval > 0) {
    final elapsed = (now - lastDone) / kDayMs;
    t = math.max(t, _clamp(elapsed / interval));
  }
  return t;
}

/// STOCK: quantity against a reorder point. full -> 0, empty -> 1.
double stockSignal(Map<String, Object?> a, int now) {
  final qty = _num(a['qty']);
  final reorderAt = _num(a['reorderAt']);
  if (qty != null && reorderAt != null && reorderAt != 0) {
    return _clamp((reorderAt - qty) / reorderAt);
  }
  return 0;
}

/// PROGRESS: incomplete steps / total. all done -> 0, nothing done -> 1.
double progressSignal(Map<String, Object?> a, int now) {
  final steps = a['steps'];
  if (steps is List && steps.isNotEmpty) {
    final done = steps.where((s) => (s is Map) && s['done'] == true).length;
    return _clamp(1 - done / steps.length);
  }
  return 0;
}

/// RETENTION: closeness to / past an archive/expiry date.
double retentionSignal(Map<String, Object?> a, int now) {
  final arch = _int(a['archiveDate']);
  if (arch != null) {
    final win = _num(a['warnDays']) ?? 30;
    final daysLeft = (arch - now) / kDayMs;
    var r = _clamp(1 - daysLeft / win);
    if (daysLeft < 0) r = 1;
    return r;
  }
  return 0;
}

/// Mutable registry so themes can add signals without touching the engine.
class SignalRegistry {
  final Map<String, Signal> _signals;

  SignalRegistry._(this._signals);

  /// The four built-ins that already cover all 10 bundles.
  factory SignalRegistry.builtin() => SignalRegistry._({
        'time': timeSignal,
        'stock': stockSignal,
        'progress': progressSignal,
        'retention': retentionSignal,
      });

  void register(String key, Signal signal) => _signals[key] = signal;

  Iterable<String> get keys => _signals.keys;

  double compute(String key, Map<String, Object?> attrs, int now) =>
      (_signals[key] ?? (_, __) => 0.0)(attrs, now);
}
