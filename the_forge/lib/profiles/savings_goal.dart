import 'package:forge_core/forge_core.dart';

/// Savings Goal — "Wie viel habe ich schon gespart?"
/// Pure stock signal: current amount vs. target.
final savingsGoal = Profile(
  id: 'savings_goal',
  title: 'Sparziele',
  view: ViewId.grid,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Aktuell gespart (€)', 'double', required: true),
    FieldSpec('reorderAt', 'Ziel (€)', 'double', required: true),
  ],
  actions: const ['setQty', 'archive'],
  filter: (item) => item.state == ItemState.active && item.type == 'savings_goal',
  skin: const {'icon': 'savings'},
);
