import 'package:flutter/material.dart';
import 'package:forge_core/forge_core.dart';

/// Notification scheduling service.
/// Wraps flutter_local_notifications. Schedules reminders based on engine status.
///
/// Architecture: The engine computes urgency. This service translates
/// urgency + item attrs into notification schedules. No business logic here —
/// that stays in forge_core.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  bool _initialized = false;

  /// Call once at app start. In production this initializes
  /// flutter_local_notifications. For now we stub it.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    // TODO: Initialize flutter_local_notifications plugin here
    // final plugin = FlutterLocalNotificationsPlugin();
    // await plugin.initialize(...);
    debugPrint('[NotificationService] initialized (stub)');
  }

  /// Schedule notifications for all active items that need reminders.
  /// Called after every state change (complete, snooze, add, etc.)
  Future<void> rescheduleAll(List<Item> items) async {
    if (!_initialized) return;

    // Cancel all existing
    await _cancelAll();

    final now = DateTime.now().millisecondsSinceEpoch;
    const day = 86400000;

    for (final item in items) {
      if (item.state != ItemState.active) continue;

      // Skip snoozed items until their snooze expires
      final snoozeUntil = item.attrs['snoozeUntil'] as int?;
      if (snoozeUntil != null && snoozeUntil > now) continue;

      final triggerAt = _computeTriggerTime(item, now);
      if (triggerAt != null && triggerAt > now) {
        await _scheduleNotification(
          id: item.id.hashCode,
          title: _titleForItem(item),
          body: item.title,
          scheduledAt: DateTime.fromMillisecondsSinceEpoch(triggerAt),
        );
      }
    }
  }

  /// Compute when this item should fire a notification.
  int? _computeTriggerTime(Item item, int now) {
    const day = 86400000;
    final attrs = item.attrs;

    // Items with dueDate: notify at (dueDate - warnDays)
    final dueDate = attrs['dueDate'] as int?;
    if (dueDate != null) {
      final warnDays = (attrs['warnDays'] as num?)?.toInt() ?? 1;
      return dueDate - (warnDays * day);
    }

    // Items with interval: notify when interval elapsed
    final interval = (attrs['intervalDays'] as num?)?.toInt();
    final lastDone = attrs['lastDone'] as int?;
    if (interval != null && lastDone != null) {
      return lastDone + (interval * day);
    }

    // Items with archiveDate: notify warnDays before
    final archiveDate = attrs['archiveDate'] as int?;
    if (archiveDate != null) {
      final warnDays = (attrs['warnDays'] as num?)?.toInt() ?? 7;
      return archiveDate - (warnDays * day);
    }

    return null;
  }

  String _titleForItem(Item item) {
    final status = evaluate(item, DateTime.now().millisecondsSinceEpoch);
    return switch (status.bucket) {
      Bucket.critical => '⚠️ Überfällig',
      Bucket.due => '🔔 Fällig',
      Bucket.soon => '📋 Bald fällig',
      Bucket.ok => '✓ Erinnerung',
    };
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    // TODO: Replace with actual flutter_local_notifications call:
    // await _plugin.zonedSchedule(id, title, body, scheduledAt, ...);
    debugPrint(
        '[Notify] scheduled: "$body" at ${scheduledAt.toIso8601String()}');
  }

  Future<void> _cancelAll() async {
    // TODO: await _plugin.cancelAll();
    debugPrint('[Notify] cancelled all');
  }

  /// Cancel notifications for a specific item (e.g. on complete/archive).
  Future<void> cancelForItem(String itemId) async {
    // TODO: await _plugin.cancel(itemId.hashCode);
    debugPrint('[Notify] cancelled for $itemId');
  }
}
