/// P4 — Transitions: the verbs that turn a status into an interactive app.
/// Each is pure: takes an item, returns a NEW item with updated history.

import 'item.dart';

List<HistoryEntry> _log(Item i, int now, String verb, [Map<String, Object?> meta = const {}]) =>
    [...i.history, HistoryEntry(now, verb, meta)];

/// COMPLETE. Recurring items (have intervalDays) reset their clock and stay
/// active; one-shot items become done.
Item complete(Item i, int now) {
  final recurring = i.attrs.containsKey('intervalDays');
  if (recurring) {
    return i.copyWith(
      attrs: {...i.attrs, 'lastDone': now},
      state: ItemState.active,
      history: _log(i, now, 'complete'),
      updatedAt: now,
    );
  }
  return i.copyWith(
    state: ItemState.done,
    history: _log(i, now, 'complete'),
    updatedAt: now,
  );
}

/// SNOOZE for [days]. Records intent; engine stays the single source of truth.
Item snooze(Item i, int now, {required int days}) {
  return i.copyWith(
    attrs: {...i.attrs, 'snoozeUntil': now + days * 86400000},
    state: ItemState.snoozed,
    history: _log(i, now, 'snooze', {'days': days}),
    updatedAt: now,
  );
}

/// ARCHIVE. Out of sight, kept for the record.
Item archive(Item i, int now) => i.copyWith(
      state: ItemState.archived,
      history: _log(i, now, 'archive'),
      updatedAt: now,
    );

/// RESET a routine: clear all steps, back to active.
Item reset(Item i, int now) {
  final steps = i.attrs['steps'];
  final cleared = steps is List
      ? steps
          .map((s) => s is Map ? {...s.cast<String, Object?>(), 'done': false} : s)
          .toList()
      : steps;
  return i.copyWith(
    attrs: {...i.attrs, if (cleared != null) 'steps': cleared, 'lastDone': now},
    state: ItemState.active,
    history: _log(i, now, 'reset'),
    updatedAt: now,
  );
}

/// SET QUANTITY (inventory). Used for restock or consumption.
Item setQty(Item i, int now, double qty) => i.copyWith(
      attrs: {...i.attrs, 'qty': qty},
      history: _log(i, now, 'setQty', {'qty': qty}),
      updatedAt: now,
    );

/// TOGGLE one step of a routine by index.
Item toggleStep(Item i, int now, int index) {
  final steps = i.attrs['steps'];
  if (steps is! List || index < 0 || index >= steps.length) return i;
  final next = [...steps];
  final s = (next[index] as Map).cast<String, Object?>();
  next[index] = {...s, 'done': !(s['done'] == true)};
  return i.copyWith(
    attrs: {...i.attrs, 'steps': next},
    history: _log(i, now, 'toggleStep', {'index': index}),
    updatedAt: now,
  );
}
