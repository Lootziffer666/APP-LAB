import 'package:flutter/material.dart';
import 'package:forge_core/forge_core.dart';

import 'forge_colors.dart';

/// The single bridge between the engine's Bucket and the FLUBBER design system.
/// If this class is correct, every item renders correctly regardless of theme.
class ForgeDesignBridge {
  const ForgeDesignBridge._();
  static const instance = ForgeDesignBridge._();

  /// Bucket → accent color.
  Color bucketColor(Bucket bucket) => switch (bucket) {
        Bucket.ok => ForgeColors.ok,
        Bucket.soon => ForgeColors.soon,
        Bucket.due => ForgeColors.due,
        Bucket.critical => ForgeColors.critical,
      };

  /// Bucket → background tint (low alpha, for card fills).
  Color bucketTint(Bucket bucket) =>
      bucketColor(bucket).withAlpha(bucket == Bucket.ok ? 0 : 25);

  /// Bucket → border beam active? (only due + critical warrant attention-grabbing)
  bool bucketBeamActive(Bucket bucket) =>
      bucket == Bucket.due || bucket == Bucket.critical;

  /// Bucket → energy line mode. Maps directly to KYUUBI's LuminousMode concept.
  /// Returns null for ok (no line needed).
  String? bucketLuminousMode(Bucket bucket) => switch (bucket) {
        Bucket.ok => null,
        Bucket.soon => 'calm',
        Bucket.due => 'pressure',
        Bucket.critical => 'urgent',
      };

  /// Bucket → animation duration (faster = more urgent).
  Duration bucketAnimDuration(Bucket bucket) => switch (bucket) {
        Bucket.ok => const Duration(milliseconds: 600),
        Bucket.soon => const Duration(milliseconds: 3200),
        Bucket.due => const Duration(milliseconds: 1800),
        Bucket.critical => const Duration(milliseconds: 800),
      };

  /// Bucket → easing curve (FLUBBER motion grammar).
  Curve bucketCurve(Bucket bucket) => switch (bucket) {
        Bucket.ok => Curves.easeOut,
        Bucket.soon => Curves.easeInOut, // smooth_glide
        Bucket.due => const _BouncyJelly(), // cubic-bezier(0.175, 0.885, 0.32, 1.275)
        Bucket.critical => const _ElasticSnap(), // cubic-bezier(0.68, -0.55, 0.265, 1.55)
      };

  /// Status label for accessibility / screen readers.
  String bucketLabel(Bucket bucket) => switch (bucket) {
        Bucket.ok => 'In Ordnung',
        Bucket.soon => 'Bald fällig',
        Bucket.due => 'Fällig',
        Bucket.critical => 'Überfällig',
      };

  /// Icon for bucket badge.
  IconData bucketIcon(Bucket bucket) => switch (bucket) {
        Bucket.ok => Icons.check_circle_outline_rounded,
        Bucket.soon => Icons.schedule_rounded,
        Bucket.due => Icons.warning_amber_rounded,
        Bucket.critical => Icons.error_outline_rounded,
      };
}

/// FLUBBER bouncy_jelly: cubic-bezier(0.175, 0.885, 0.32, 1.275)
class _BouncyJelly extends Curve {
  const _BouncyJelly();

  @override
  double transformInternal(double t) {
    // Attempt to approximate cubic-bezier(0.175, 0.885, 0.32, 1.275)
    // Using a spring-like overshoot
    final p = t - 1;
    return 1 + p * p * (2.275 * p + 1.275);
  }
}

/// FLUBBER elastic_snap: cubic-bezier(0.68, -0.55, 0.265, 1.55)
class _ElasticSnap extends Curve {
  const _ElasticSnap();

  @override
  double transformInternal(double t) {
    if (t < 0.5) {
      return 2 * t * t * (3.5 * t - 0.55);
    }
    final p = 2 * t - 2;
    return 0.5 * (p * p * (3.5 * p + 0.55) + 2);
  }
}
