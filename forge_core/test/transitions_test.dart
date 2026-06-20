import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

final int now = DateTime.utc(2026, 6, 19, 9).millisecondsSinceEpoch;
const int day = 86400000;

Item base(Map<String, Object?> attrs) => Item(
      id: 'x',
      type: 't',
      title: 'x',
      attrs: attrs,
      createdAt: now,
      updatedAt: now,
    );

void main() {
  test('complete on recurring item resets clock, stays active', () {
    final i = base({'intervalDays': 7, 'lastDone': now - 6 * day});
    final c = complete(i, now);
    expect(c.state, ItemState.active);
    expect(c.attrs['lastDone'], now);
    expect(c.history.last.verb, 'complete');
  });

  test('complete on one-shot item becomes done', () {
    final i = base({'dueDate': now + day});
    final c = complete(i, now);
    expect(c.state, ItemState.done);
  });

  test('snooze records intent and flips state', () {
    final c = snooze(base({'dueDate': now}), now, days: 3);
    expect(c.state, ItemState.snoozed);
    expect(c.attrs['snoozeUntil'], now + 3 * day);
  });

  test('reset clears routine steps', () {
    final i = base({
      'steps': [
        {'t': 'a', 'done': true},
        {'t': 'b', 'done': true},
      ]
    });
    final r = reset(i, now);
    final steps = (r.attrs['steps'] as List).cast<Map>();
    expect(steps.every((s) => s['done'] == false), isTrue);
    expect(r.state, ItemState.active);
  });

  test('toggleStep flips a single step, drives progress signal', () {
    final i = base({
      'steps': [
        {'t': 'a', 'done': false},
        {'t': 'b', 'done': false},
      ]
    }).copyWith(weights: {'progress': 1});
    expect(evaluate(i, now).urgency, 1.0); // nothing done
    final t = toggleStep(i, now, 0);
    expect(evaluate(t, now).urgency, 0.5); // half done
    expect(t.history.last.verb, 'toggleStep');
  });

  test('transitions are pure: original item unchanged', () {
    final i = base({'qty': 5.0, 'reorderAt': 10});
    final after = setQty(i, now, 99);
    expect(i.attrs['qty'], 5.0); // untouched
    expect(after.attrs['qty'], 99.0);
  });
}
