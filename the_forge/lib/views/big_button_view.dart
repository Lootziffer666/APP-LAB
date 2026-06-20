import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';

/// Big-Button view — used for Senior Simple Mode and Kids profiles.
/// Shows max 6–8 items as large, tappable tiles. Minimal text, maximum clarity.
class BigButtonView extends ConsumerWidget {
  const BigButtonView({super.key, required this.items, required this.profile});

  final List<Item> items;
  final Profile profile;
  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Keine Einträge.', style: TextStyle(fontSize: 18)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length.clamp(0, 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final status = evaluateItem(item);
          final color = _bridge.bucketColor(status.bucket);

          return _BigTile(
            item: item,
            color: color,
            onTap: () {
              HapticFeedback.mediumImpact();
              ref.read(storeProvider.notifier).completeItem(item.id);
            },
          );
        },
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  const _BigTile({required this.item, required this.color, this.onTap});

  final Item item;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ForgeColors.night,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(100), width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 36,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
