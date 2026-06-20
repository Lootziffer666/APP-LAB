import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';

/// Grid/Inventory view — used by Household Inventory profile.
/// Shows items as compact tiles with quantity badge and location.
class InventoryGridView extends ConsumerWidget {
  const InventoryGridView({super.key, required this.items, required this.profile});

  final List<Item> items;
  final Profile profile;
  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: ForgeColors.muted),
              SizedBox(height: 16),
              Text('Regal ist leer.', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _InventoryTile(
        item: items[index],
        onTap: () => _showQtyDialog(context, ref, items[index]),
      ),
    );
  }

  void _showQtyDialog(BuildContext context, WidgetRef ref, Item item) {
    final ctrl = TextEditingController(text: '${item.attrs['qty'] ?? 0}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.title),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Neue Menge'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              final qty = double.tryParse(ctrl.text);
              if (qty != null) {
                HapticFeedback.mediumImpact();
                ref.read(storeProvider.notifier).setItemQty(item.id, qty);
              }
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    ctrl.dispose;
  }
}

class _InventoryTile extends StatelessWidget {
  const _InventoryTile({required this.item, this.onTap});

  final Item item;
  final VoidCallback? onTap;
  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context) {
    final status = evaluateItem(item);
    final color = _bridge.bucketColor(status.bucket);
    final qty = item.attrs['qty'];
    final reorder = item.attrs['reorderAt'];
    final location = item.attrs['location'] as String?;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ForgeColors.night,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withAlpha(status.bucket == Bucket.ok ? 30 : 100),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Location
            if (location != null && location.isNotEmpty)
              Text(
                location,
                style: TextStyle(
                  fontSize: 11,
                  color: ForgeColors.muted.withAlpha(150),
                ),
                maxLines: 1,
              ),
            // Quantity row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Qty badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$qty',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (reorder != null)
                  Text(
                    '/ $reorder',
                    style: TextStyle(
                      fontSize: 11,
                      color: ForgeColors.muted.withAlpha(120),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
