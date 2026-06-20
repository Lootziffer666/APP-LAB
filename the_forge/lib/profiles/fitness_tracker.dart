import 'package:forge_core/forge_core.dart';

/// Simple Fitness / Habit Tracker — interval-based "did you do it today?".
/// Not a full workout app. Just: "Habe ich heute Sport gemacht?"
final fitnessTracker = Profile(
  id: 'fitness_tracker',
  title: 'Fitness & Gewohnheiten',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'fitness_tracker',
  skin: const {'icon': 'fitness_center'},
);
