import 'package:forge_core/forge_core.dart';

/// Gratitude / Journaling prompt — daily "Wofür bist du dankbar?"
final gratitudeLog = Profile(
  id: 'gratitude_log',
  title: 'Dankbarkeit',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Jeden Tag (1)', 'int'),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete'],
  filter: (item) => item.state == ItemState.active && item.type == 'gratitude_log',
  skin: const {'icon': 'favorite'},
);
