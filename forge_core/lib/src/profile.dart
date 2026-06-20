/// P8 — Profile: the "app" expressed as pure data. Adding an app = adding one
/// of these, no new core code. Views and skins resolve on the Flutter side.

import 'item.dart';

/// The finite set of view archetypes every app maps onto.
enum ViewId { list, calendar, board, grid, bigButton, launcher }

/// Declares one editable/visible attribute for an item within a profile.
class FieldSpec {
  final String key; // attrs key
  final String label;
  final String kind; // "date" | "int" | "double" | "text" | "steps" | "file"
  final bool required;

  const FieldSpec(this.key, this.label, this.kind, {this.required = false});
}

/// A "Micro-App" as configuration.
class Profile {
  final String id;
  final String title;
  final ViewId view;

  /// Weights applied to new items created under this profile.
  final Map<String, double> defaultWeights;

  final List<FieldSpec> fields;
  final List<String> actions; // verb ids: complete, snooze, reset, archive, setQty...

  /// Which items belong to this app's shelf.
  final bool Function(Item item)? filter;

  /// Opaque skin tokens consumed by the design system (liquid/elastic, Lottie).
  final Map<String, Object?> skin;

  const Profile({
    required this.id,
    required this.title,
    required this.view,
    this.defaultWeights = const {},
    this.fields = const [],
    this.actions = const [],
    this.filter,
    this.skin = const {},
  });

  Iterable<Item> select(Iterable<Item> items) =>
      filter == null ? items : items.where(filter!);

  /// Stamp a freshly captured item with this profile's defaults.
  Item brand(Item draft) => draft.copyWith(
        weights: draft.weights.isEmpty ? defaultWeights : draft.weights,
      );
}
