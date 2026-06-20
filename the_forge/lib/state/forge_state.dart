import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'demo_seed.dart';
import '../services/notification_service.dart';

const _uuid = Uuid();

/// Provides the single store instance, initialized from disk.
final storeProvider = StateNotifierProvider<ForgeStoreNotifier, List<Item>>((ref) {
  return ForgeStoreNotifier();
});

/// Wraps the forge_core [InMemoryStore] with persistence + Riverpod integration.
class ForgeStoreNotifier extends StateNotifier<List<Item>> {
  ForgeStoreNotifier() : super([]) {
    _load();
  }

  final InMemoryStore _store = InMemoryStore();
  File? _file;

  Future<void> _load() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _file = File('${dir.path}/forge_items.json');
      if (await _file!.exists()) {
        final json = await _file!.readAsString();
        _store.import(json);
        state = _store.all();
      } else {
        // First launch — seed with demo items
        for (final item in demoSeedItems()) {
          _store.upsert(item);
        }
        _persist();
      }
    } catch (_) {
      // First launch or corrupted file — seed with demo
      for (final item in demoSeedItems()) {
        _store.upsert(item);
      }
      state = _store.all();
    }
  }

  Future<void> _persist() async {
    state = _store.all();
    if (_file != null) {
      await _file!.writeAsString(_store.export());
    }
    // Reschedule notifications after every change
    NotificationService.instance.rescheduleAll(state);
  }

  // ── Public API (verbs) ──────────────────────────────────────────────────

  String addItem({
    required String title,
    required String type,
    required Map<String, Object?> attrs,
    required Map<String, double> weights,
    String? parentId,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final item = Item(
      id: _uuid.v4(),
      type: type,
      title: title,
      attrs: attrs,
      weights: weights,
      parentId: parentId,
      createdAt: now,
      updatedAt: now,
    );
    _store.upsert(item);
    _persist();
    return item.id;
  }

  void completeItem(String id) => _apply(id, complete);
  void snoozeItem(String id, {int days = 1}) =>
      _applyWith(id, (i, now) => snooze(i, now, days: days));
  void archiveItem(String id) => _apply(id, archive);
  void resetItem(String id) => _apply(id, reset);
  void setItemQty(String id, double qty) =>
      _applyWith(id, (i, now) => setQty(i, now, qty));
  void toggleItemStep(String id, int index) =>
      _applyWith(id, (i, now) => toggleStep(i, now, index));

  void removeItem(String id) {
    _store.remove(id);
    _persist();
  }

  /// Full JSON export for user backup.
  String exportAll() => _store.export();

  /// Full JSON import (replaces everything).
  void importAll(String json) {
    _store.import(json);
    _persist();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  void _apply(String id, Item Function(Item, int) transition) {
    final item = _store.byId(id);
    if (item == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _store.upsert(transition(item, now));
    _persist();
  }

  void _applyWith(String id, Item Function(Item, int) transition) {
    final item = _store.byId(id);
    if (item == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _store.upsert(transition(item, now));
    _persist();
  }
}

/// Convenience: evaluate status for display. Pure, no side effects.
StatusResult evaluateItem(Item item) =>
    evaluate(item, DateTime.now().millisecondsSinceEpoch);
