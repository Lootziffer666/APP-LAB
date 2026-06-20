import 'package:forge_core/forge_core.dart';

/// Kitchen Loop profile.
/// Fridge/pantry tracking + expiry. Stock + time combined.
final kitchenLoop = Profile(
  id: 'kitchen_loop',
  title: 'Küche & Vorrat',
  view: ViewId.grid,
  defaultWeights: const {'stock': 0.5, 'time': 0.5},
  fields: const [
    FieldSpec('qty', 'Menge', 'double', required: true),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double'),
    FieldSpec('dueDate', 'Haltbar bis', 'date'),
    FieldSpec('location', 'Ort (Kühlschrank/Regal/TK)', 'text'),
  ],
  actions: const ['setQty', 'complete', 'archive'],
  filter: (item) =>
      item.state == ItemState.active &&
      item.weights.containsKey('stock') &&
      item.type == 'kitchen_loop',
  skin: const {
    'icon': 'kitchen',
    'emptyLottie': 'assets/lottie/empty_fridge.json',
  },
);
