import 'package:forge_core/forge_core.dart';

/// Household Inventory profile.
/// Tools, screws, batteries, spices, freezer items, keys — all one shelf.
final householdInventory = Profile(
  id: 'household_inventory',
  title: 'Inventar',
  view: ViewId.grid,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Menge', 'double', required: true),
    FieldSpec('reorderAt', 'Nachbestellen ab', 'double', required: true),
    FieldSpec('location', 'Ort', 'text'),
    FieldSpec('photo', 'Foto', 'file'),
  ],
  actions: const ['setQty', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'household_inventory',
  skin: const {
    'icon': 'inventory_2',
    'emptyLottie': 'assets/lottie/empty_shelf.json',
  },
);
