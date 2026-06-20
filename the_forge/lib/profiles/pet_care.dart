import 'package:forge_core/forge_core.dart';

/// Pet Care — feeding, vet visits, medication, grooming intervals.
/// Same engine as plant care. Same signal. Different creature.
final petCare = Profile(
  id: 'pet_care',
  title: 'Haustiere',
  view: ViewId.list,
  defaultWeights: const {'time': 0.7, 'stock': 0.3},
  fields: const [
    FieldSpec('intervalDays', 'Intervall (Tage)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('qty', 'Futtervorrat', 'double'),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double'),
  ],
  actions: const ['complete', 'setQty', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'pet_care',
  skin: const {'icon': 'pets'},
);
