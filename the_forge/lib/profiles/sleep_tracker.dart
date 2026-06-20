import 'package:forge_core/forge_core.dart';

/// Sleep / Bedtime Reminder — "Geh schlafen, es ist spät."
final sleepTracker = Profile(
  id: 'sleep_tracker',
  title: 'Schlafenszeit',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächste Schlafenszeit', 'date'),
    FieldSpec('intervalDays', 'Täglich (1)', 'int'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (item) => item.state == ItemState.active && item.type == 'sleep_tracker',
  skin: const {'icon': 'bedtime'},
);
