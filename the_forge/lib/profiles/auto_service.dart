import 'package:forge_core/forge_core.dart';

/// Auto Service Logger — TÜV, Ölwechsel, Reifenwechsel, Inspektionen.
final autoService = Profile(
  id: 'auto_service',
  title: 'Auto & Fahrzeug',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächster Termin', 'date'),
    FieldSpec('intervalDays', 'Alle X Tage', 'int'),
    FieldSpec('lastDone', 'Zuletzt erledigt', 'date'),
    FieldSpec('km', 'Kilometerstand', 'int'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'auto_service',
  skin: const {'icon': 'directions_car'},
);
