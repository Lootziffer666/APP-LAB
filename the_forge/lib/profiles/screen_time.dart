import 'package:forge_core/forge_core.dart';

/// Screen Time / Digital Detox — interval reminder to take a break.
final screenTime = Profile(
  id: 'screen_time',
  title: 'Bildschirmpause',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Pause alle X Stunden', 'int', required: true),
    FieldSpec('lastDone', 'Letzte Pause', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (item) => item.state == ItemState.active && item.type == 'screen_time',
  skin: const {'icon': 'visibility_off'},
);
