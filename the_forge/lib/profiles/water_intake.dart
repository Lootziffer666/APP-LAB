import 'package:forge_core/forge_core.dart';

/// Water Intake Reminder — "Hast du heute genug getrunken?"
final waterIntake = Profile(
  id: 'water_intake',
  title: 'Trinken',
  view: ViewId.list,
  defaultWeights: const {'time': 0.7, 'stock': 0.3},
  fields: const [
    FieldSpec('intervalDays', 'Erinnerung alle X Stunden', 'int'),
    FieldSpec('qty', 'Gläser heute', 'double'),
    FieldSpec('reorderAt', 'Tagesziel', 'double'),
  ],
  actions: const ['complete', 'setQty'],
  filter: (item) => item.state == ItemState.active && item.type == 'water_intake',
  skin: const {'icon': 'water_drop'},
);
