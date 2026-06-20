import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Gooey button with liquid deformation on press.
/// Ported from KYUUBI. Used for primary actions (complete, snooze).
/// Squishes vertically, expands horizontally (volume conservation feel).
class GooeyButton extends StatefulWidget {
  const GooeyButton({
    super.key,
    required this.label,
    this.color,
    this.onTap,
    this.icon,
    this.width,
    this.height = 52.0,
  });

  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  State<GooeyButton> createState() => _GooeyButtonState();
}

class _GooeyButtonState extends State<GooeyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _squishCtrl;
  late final Animation<double> _squishY;
  late final Animation<double> _squishX;

  @override
  void initState() {
    super.initState();
    _squishCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _squishY = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.87)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 0.87, end: 1.06)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 35),
      TweenSequenceItem(
          tween: Tween(begin: 1.06, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 45),
    ]).animate(_squishCtrl);

    _squishX = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.07)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 1.07, end: 0.97)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 35),
      TweenSequenceItem(
          tween: Tween(begin: 0.97, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 45),
    ]).animate(_squishCtrl);
  }

  @override
  void dispose() {
    _squishCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    _squishCtrl.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    if (reduce) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: FilledButton.icon(
          onPressed: widget.onTap,
          icon: widget.icon != null ? Icon(widget.icon) : const SizedBox.shrink(),
          label: Text(widget.label),
        ),
      );
    }

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _squishCtrl,
        builder: (_, __) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(_squishX.value, _squishY.value, 1),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(widget.height / 2),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(60),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: widget.width == null
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  const SizedBox(width: 20),
                  Icon(widget.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox(width: 24),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
