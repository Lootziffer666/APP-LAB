import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';

/// Board/Checklist view — used by Routine Engine profiles.
/// Shows steps as a vertical checklist with progress bar.
class BoardView extends ConsumerWidget {
  const BoardView({super.key, required this.item});

  final Item item;
  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = (item.attrs['steps'] as List?) ?? [];
    final total = steps.length;
    final done = steps.where((s) => s is Map && s['done'] == true).length;
    final progress = total > 0 ? done / total : 0.0;
    final status = evaluateItem(item);
    final color = _bridge.bucketColor(status.bucket);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + progress
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$done / $total',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: ForgeColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
            // Steps
            ...List.generate(total, (i) {
              final step = steps[i] is Map ? steps[i] as Map : <String, dynamic>{};
              final isDone = step['done'] == true;
              final label = (step['t'] ?? step['title'] ?? 'Schritt ${i + 1}') as String;

              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(storeProvider.notifier).toggleItemStep(item.id, i);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isDone ? color.withAlpha(40) : Colors.transparent,
                          border: Border.all(
                            color: isDone ? color : ForgeColors.muted.withAlpha(100),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: isDone
                            ? Icon(Icons.check_rounded, size: 14, color: color)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone
                              ? ForgeColors.muted.withAlpha(120)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Reset button at the bottom
            if (done == total && total > 0) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ref.read(storeProvider.notifier).resetItem(item.id);
                  },
                  icon: const Icon(Icons.replay_rounded, size: 16),
                  label: const Text('Zurücksetzen'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
