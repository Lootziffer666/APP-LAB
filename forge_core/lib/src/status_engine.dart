/// P3 — the single status engine. Already proven in one-engine-test.js.
/// Weighted mix of signals -> urgency -> bucket + dominant driver.

import 'item.dart';
import 'signals.dart';

/// Coarse status bucket. The same four buckets render the same way everywhere.
enum Bucket { ok, soon, due, critical }

class StatusResult {
  final double urgency; // 0..1
  final Bucket bucket;
  final String driver; // which signal dominates -> "weighting shifted"
  final Map<String, double> signals; // raw signal values, for inspection

  const StatusResult(this.urgency, this.bucket, this.driver, this.signals);
}

/// Pure. Same inputs -> same output. No theme knowledge anywhere.
StatusResult evaluate(Item item, int now, {SignalRegistry? registry}) {
  final reg = registry ?? SignalRegistry.builtin();

  final signals = <String, double>{};
  for (final key in reg.keys) {
    signals[key] = reg.compute(key, item.attrs, now);
  }

  double wsum = 0;
  for (final w in item.weights.values) {
    wsum += w;
  }
  if (wsum == 0) wsum = 1;

  double urgency = 0;
  for (final entry in item.weights.entries) {
    urgency += (signals[entry.key] ?? 0) * entry.value;
  }
  urgency = (urgency / wsum);
  urgency = double.parse(urgency.toStringAsFixed(2));

  final bucket = urgency >= 0.999
      ? Bucket.critical
      : urgency >= 0.66
          ? Bucket.due
          : urgency >= 0.34
              ? Bucket.soon
              : Bucket.ok;

  // dominant driver = argmax(signal * weight)
  var driver = signals.keys.isEmpty ? '' : signals.keys.first;
  var best = double.negativeInfinity;
  for (final key in signals.keys) {
    final weighted = (signals[key] ?? 0) * (item.weights[key] ?? 0);
    if (weighted > best) {
      best = weighted;
      driver = key;
    }
  }

  return StatusResult(urgency, bucket, driver, signals);
}
