/// P9 — Store: one local-first place for all items. JSON export/import gives
/// the user full ownership of their data (the 99ct/5e lifetime promise).

import 'dart:convert';
import 'item.dart';

abstract class Store {
  List<Item> all();
  Item? byId(String id);
  void upsert(Item item);
  void remove(String id);

  /// Full snapshot the user can save/back up anywhere.
  String export();

  /// Replace contents from a previously exported snapshot.
  void import(String json);
}

/// Reference implementation. The Flutter app swaps this for a file/SQLite-backed
/// store behind the same contract — nothing else changes.
class InMemoryStore implements Store {
  final Map<String, Item> _items = {};

  @override
  List<Item> all() => _items.values.toList(growable: false);

  @override
  Item? byId(String id) => _items[id];

  @override
  void upsert(Item item) => _items[item.id] = item;

  @override
  void remove(String id) => _items.remove(id);

  @override
  String export() => const JsonEncoder.withIndent('  ').convert({
        'version': 1,
        'items': all().map((i) => i.toJson()).toList(),
      });

  @override
  void import(String json) {
    final data = jsonDecode(json) as Map<String, Object?>;
    final items = (data['items'] as List).cast<Map>();
    _items
      ..clear()
      ..addEntries(items
          .map((m) => Item.fromJson(m.cast<String, Object?>()))
          .map((i) => MapEntry(i.id, i)));
  }
}
