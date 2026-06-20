import 'package:forge_core/forge_core.dart';

/// Plant Care profile — interval-based watering/feeding.
/// THE classic "micro app" that is really just {time:1} on the engine.
final plantCare = Profile(
  id: 'plant_care',
  title: 'Pflanzen',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Gießen alle X Tage', 'int', required: true),
    FieldSpec('location', 'Standort', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'plant_care',
  skin: const {
    'icon': 'eco',
    'emptyLottie': 'assets/lottie/garden.json',
  },
);
