import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

final int now = DateTime.utc(2026, 6, 19, 9).millisecondsSinceEpoch;
const int day = 86400000;

Item plant() => Item(
      id: 'p1',
      type: 'plant',
      title: 'Monstera',
      weights: const {'time': 1},
      attrs: {'intervalDays': 7, 'lastDone': now - 6 * day},
      createdAt: now,
      updatedAt: now,
    );

Item contract() => Item(
      id: 'c1',
      type: 'contract',
      title: 'Handytarif',
      weights: const {'time': 1},
      attrs: {'dueDate': now + 5 * day, 'warnDays': 30},
      createdAt: now,
      updatedAt: now,
    );

void main() {
  test('store JSON export/import round-trips losslessly', () {
    final s = InMemoryStore()
      ..upsert(plant())
      ..upsert(complete(contract(), now));

    final dump = s.export();
    final s2 = InMemoryStore()..import(dump);

    expect(s2.all().length, 2);
    final c = s2.byId('c1')!;
    expect(c.state, ItemState.done);
    expect(c.history.last.verb, 'complete');
    // engine produces identical result after a round-trip
    expect(evaluate(s2.byId('p1')!, now).urgency, evaluate(plant(), now).urgency);
  });

  test('an "app" is just a Profile (data): filtering + branding', () {
    final deadlineLedger = Profile(
      id: 'deadline_ledger',
      title: 'Deadline Ledger',
      view: ViewId.list,
      defaultWeights: const {'time': 1},
      actions: const ['complete', 'snooze', 'archive', 'reset'],
      filter: (i) => i.weights.containsKey('time'),
    );

    final inventory = Profile(
      id: 'inventory',
      title: 'Household Inventory',
      view: ViewId.grid,
      defaultWeights: const {'stock': 1},
      actions: const ['setQty', 'archive'],
      filter: (i) => i.weights.containsKey('stock'),
    );

    final all = [plant(), contract()];
    expect(deadlineLedger.select(all).length, 2); // both time-driven
    expect(inventory.select(all).length, 0); // none stock-driven

    // branding a freshly captured draft stamps the profile's weights
    final draft = Item(
        id: 'new', type: 'misc', title: 'Schrauben', createdAt: now, updatedAt: now);
    final branded = inventory.brand(draft);
    expect(branded.weights, {'stock': 1});
  });
}
