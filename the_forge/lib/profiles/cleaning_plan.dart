import 'package:forge_core/forge_core.dart';

/// Cleaning Plan — recurring household tasks with interval.
/// Same engine as plant watering. Same signal. Different label.
final cleaningPlan = Profile(
  id: 'cleaning_plan',
  title: 'Putzplan',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('location', 'Raum / Bereich', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'cleaning_plan',
  skin: const {
    'icon': 'cleaning_services',
    'emptyLottie': 'assets/lottie/sparkling.json',
  },
);
