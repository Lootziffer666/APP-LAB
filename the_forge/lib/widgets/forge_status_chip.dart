import 'package:flutter/material.dart';
import 'package:forge_core/forge_core.dart';

import '../theme/forge_design_bridge.dart';

/// Compact status badge that maps engine [Bucket] → visual chip.
/// Adapted from KYUUBI StatusChip for The Forge's universal bucket system.
class ForgeStatusChip extends StatelessWidget {
  const ForgeStatusChip({super.key, required this.bucket});

  final Bucket bucket;
  static const _bridge = ForgeDesignBridge.instance;

  @override
  Widget build(BuildContext context) {
    final color = _bridge.bucketColor(bucket);
    final label = _bridge.bucketLabel(bucket);
    final icon = _bridge.bucketIcon(bucket);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(128)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
