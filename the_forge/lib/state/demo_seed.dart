import 'package:forge_core/forge_core.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Demo items seeded on first launch. Shows the engine's power
/// across different "apps" without the user needing to add anything.
List<Item> demoSeedItems() {
  final now = DateTime.now().millisecondsSinceEpoch;
  const day = 86400000;

  return [
    // Deadline Ledger
    Item(
      id: _uuid.v4(),
      type: 'deadline_ledger',
      title: 'Handytarif kündigen',
      weights: const {'time': 1},
      attrs: {'dueDate': now + 5 * day, 'warnDays': 30},
      createdAt: now,
      updatedAt: now,
    ),
    Item(
      id: _uuid.v4(),
      type: 'deadline_ledger',
      title: 'TÜV / HU',
      weights: const {'time': 1},
      attrs: {'dueDate': now + 45 * day, 'warnDays': 30},
      createdAt: now,
      updatedAt: now,
    ),
    // Plant Care
    Item(
      id: _uuid.v4(),
      type: 'plant_care',
      title: 'Monstera gießen',
      weights: const {'time': 1},
      attrs: {'intervalDays': 7, 'lastDone': now - 6 * day},
      createdAt: now,
      updatedAt: now,
    ),
    Item(
      id: _uuid.v4(),
      type: 'plant_care',
      title: 'Basilikum',
      weights: const {'time': 1},
      attrs: {'intervalDays': 2, 'lastDone': now - 3 * day},
      createdAt: now,
      updatedAt: now,
    ),
    // Medication
    Item(
      id: _uuid.v4(),
      type: 'medication_tracker',
      title: 'Vitamin D',
      weights: const {'time': 0.6, 'stock': 0.4},
      attrs: {
        'intervalDays': 1,
        'lastDone': now - 1 * day,
        'qty': 8,
        'reorderAt': 10,
      },
      createdAt: now,
      updatedAt: now,
    ),
    // Household Inventory
    Item(
      id: _uuid.v4(),
      type: 'household_inventory',
      title: 'Spax 4x40',
      weights: const {'stock': 1},
      attrs: {'qty': 3, 'reorderAt': 20, 'location': 'Werkstatt Regal 2'},
      createdAt: now,
      updatedAt: now,
    ),
    Item(
      id: _uuid.v4(),
      type: 'household_inventory',
      title: 'AA Batterien',
      weights: const {'stock': 1},
      attrs: {'qty': 12, 'reorderAt': 8, 'location': 'Schublade Flur'},
      createdAt: now,
      updatedAt: now,
    ),
    // Kitchen Loop
    Item(
      id: _uuid.v4(),
      type: 'kitchen_loop',
      title: 'Milch',
      weights: const {'stock': 0.5, 'time': 0.5},
      attrs: {
        'qty': 1,
        'reorderAt': 3,
        'dueDate': now + 2 * day,
        'warnDays': 7,
        'location': 'Kühlschrank',
      },
      createdAt: now,
      updatedAt: now,
    ),
    // Routine Engine
    Item(
      id: _uuid.v4(),
      type: 'routine_engine',
      title: 'Morgenroutine',
      weights: const {'progress': 1},
      attrs: {
        'steps': [
          {'t': 'Anziehen', 'done': true},
          {'t': 'Zähne putzen', 'done': false},
          {'t': 'Frühstück', 'done': false},
          {'t': 'Schuhe', 'done': false},
        ],
      },
      createdAt: now,
      updatedAt: now,
    ),
    // Document Brain
    Item(
      id: _uuid.v4(),
      type: 'document_brain',
      title: 'Stromrechnung 2016 (10J-Frist)',
      weights: const {'retention': 1},
      attrs: {'archiveDate': now - 2 * day, 'warnDays': 30},
      createdAt: now,
      updatedAt: now,
    ),
  ];
}
