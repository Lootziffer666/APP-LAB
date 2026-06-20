import 'package:forge_core/forge_core.dart';

/// Medication / Supplement Tracker.
/// THE proof case: intake (time) + supply (stock) in ONE weight vector.
/// This is what other apps sell as TWO separate products.
final medicationTracker = Profile(
  id: 'medication_tracker',
  title: 'Medikamente',
  view: ViewId.list,
  defaultWeights: const {'time': 0.6, 'stock': 0.4},
  fields: const [
    FieldSpec('intervalDays', 'Einnahme alle X Tage', 'int', required: true),
    FieldSpec('qty', 'Vorrat (Stück)', 'double', required: true),
    FieldSpec('reorderAt', 'Nachbestellen ab', 'double', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
  ],
  actions: const ['complete', 'setQty', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'medication_tracker',
  skin: const {
    'icon': 'medication',
    'emptyLottie': 'assets/lottie/healthy.json',
  },
);
