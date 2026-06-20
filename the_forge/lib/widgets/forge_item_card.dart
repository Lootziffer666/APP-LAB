import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../animations/border_beam.dart';
import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';

/// Universal item card. Renders ANY item from ANY profile.
/// The design bridge maps the engine's bucket → visual treatment automatically.
/// BorderBeam activates on due/critical items for visual urgency.
class ForgeItemCard extends ConsumerWidget {
  const ForgeItemCard({
    super.key,
    required this.item,
    required this.profile,
  });

  final Item item;
  final Profile profile;

  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = evaluateItem(item);
    final color = _bridge.bucketColor(status.bucket);
    final showBeam = _bridge.bucketBeamActive(status.bucket);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          color: ForgeColors.ok.withAlpha(40),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.check_rounded, color: ForgeColors.ok, size: 28),
      ),
      confirmDismiss: (_) async {
        HapticFeedback.mediumImpact();
        ref.read(storeProvider.notifier).completeItem(item.id);
        return false; // we handle removal ourselves
      },
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.heavyImpact();
          _showActions(context, ref, status);
        },
        child: BorderBeam(
          active: showBeam,
          color: color,
          child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: showBeam ? color.withAlpha(180) : ForgeColors.divider.withAlpha(40),
              width: showBeam ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Bucket indicator dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: showBeam
                        ? [BoxShadow(color: color.withAlpha(100), blurRadius: 6)]
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(item, status),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: color.withAlpha(200),
                            ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                // Urgency badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _bridge.bucketLabel(status.bucket),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  String _subtitle(Item item, StatusResult status) {
    final attrs = item.attrs;
    // Time-driven: show days until due
    if (attrs.containsKey('dueDate')) {
      final due = attrs['dueDate'] as int;
      final days = ((due - DateTime.now().millisecondsSinceEpoch) / 86400000).round();
      if (days < 0) return 'Seit ${-days} Tag(en) überfällig';
      if (days == 0) return 'Heute fällig';
      return 'In $days Tag(en)';
    }
    // Interval-driven
    if (attrs.containsKey('intervalDays') && attrs.containsKey('lastDone')) {
      final interval = (attrs['intervalDays'] as num).toInt();
      final lastDone = attrs['lastDone'] as int;
      final elapsed = ((DateTime.now().millisecondsSinceEpoch - lastDone) / 86400000).round();
      return 'Tag $elapsed / $interval';
    }
    // Stock-driven
    if (attrs.containsKey('qty') && attrs.containsKey('reorderAt')) {
      return '${attrs['qty']} / ${attrs['reorderAt']} vorhanden';
    }
    // Progress-driven
    if (attrs.containsKey('steps') && attrs['steps'] is List) {
      final steps = attrs['steps'] as List;
      final done = steps.where((s) => s is Map && s['done'] == true).length;
      return '$done / ${steps.length} erledigt';
    }
    return item.type;
  }

  void _showActions(BuildContext context, WidgetRef ref, StatusResult status) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profile.actions.contains('complete'))
              ListTile(
                leading: const Icon(Icons.check_rounded, color: ForgeColors.ok),
                title: const Text('Erledigt'),
                onTap: () {
                  ref.read(storeProvider.notifier).completeItem(item.id);
                  Navigator.pop(context);
                },
              ),
            if (profile.actions.contains('snooze'))
              ListTile(
                leading: const Icon(Icons.snooze_rounded, color: ForgeColors.soon),
                title: const Text('Erinnere mich morgen'),
                onTap: () {
                  ref.read(storeProvider.notifier).snoozeItem(item.id, days: 1);
                  Navigator.pop(context);
                },
              ),
            if (profile.actions.contains('reset'))
              ListTile(
                leading: const Icon(Icons.replay_rounded, color: ForgeColors.periwinkle),
                title: const Text('Zurücksetzen'),
                onTap: () {
                  ref.read(storeProvider.notifier).resetItem(item.id);
                  Navigator.pop(context);
                },
              ),
            if (profile.actions.contains('archive'))
              ListTile(
                leading: const Icon(Icons.archive_rounded, color: ForgeColors.muted),
                title: const Text('Archivieren'),
                onTap: () {
                  ref.read(storeProvider.notifier).archiveItem(item.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
