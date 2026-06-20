import 'package:forge_core/forge_core.dart';

/// Warranty & Receipt Tracker.
/// "When does my warranty expire?" — pure time signal.
final warrantyTracker = Profile(
  id: 'warranty_tracker',
  title: 'Garantien',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Garantie läuft ab am', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('purchasePrice', 'Kaufpreis (€)', 'double'),
    FieldSpec('store', 'Gekauft bei', 'text'),
  ],
  actions: const ['archive', 'snooze'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'warranty_tracker',
  skin: const {
    'icon': 'verified_user',
    'emptyLottie': 'assets/lottie/safe.json',
  },
);
