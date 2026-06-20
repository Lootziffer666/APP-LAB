import 'package:flutter/material.dart';

/// Tap-ripple feedback — concentric circles expanding from touch point.
/// Ported from KYUUBI. Used on every card tap/complete action.
class PressRipple extends StatefulWidget {
  const PressRipple({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.maxRadius = 80.0,
    this.duration = const Duration(milliseconds: 380),
    this.ringCount = 3,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double maxRadius;
  final Duration duration;
  final int ringCount;

  @override
  State<PressRipple> createState() => PressRippleState();
}

class PressRippleState extends State<PressRipple>
    with SingleTickerProviderStateMixin {
  final List<_RippleInstance> _active = [];

  void rippleAt(Offset localPosition) {
    if (!mounted) return;
    final ctrl = AnimationController(vsync: this, duration: widget.duration);
    final instance = _RippleInstance(origin: localPosition, ctrl: ctrl);
    setState(() => _active.add(instance));
    ctrl.forward().then((_) {
      if (mounted) setState(() => _active.remove(instance));
      ctrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final ringColor = widget.color ??
        Theme.of(context).colorScheme.onSurface.withAlpha(56);

    if (reduceMotion) {
      return GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: (d) => rippleAt(d.localPosition),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: _active.isEmpty
                  ? const SizedBox.shrink()
                  : RepaintBoundary(
                      child: CustomPaint(
                        painter: _RipplePainter(
                          instances: List.unmodifiable(_active),
                          color: ringColor,
                          maxRadius: widget.maxRadius,
                          ringCount: widget.ringCount,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RippleInstance {
  _RippleInstance({required this.origin, required this.ctrl});
  final Offset origin;
  final AnimationController ctrl;
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.instances,
    required this.color,
    required this.maxRadius,
    required this.ringCount,
  }) : super(
          repaint: Listenable.merge(instances.map((i) => i.ctrl).toList()),
        );

  final List<_RippleInstance> instances;
  final Color color;
  final double maxRadius;
  final int ringCount;

  @override
  void paint(Canvas canvas, Size size) {
    for (final inst in instances) {
      final t = inst.ctrl.value;
      for (var r = 0; r < ringCount; r++) {
        final delay = r / ringCount * 0.35;
        final localT = ((t - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        if (localT <= 0) continue;
        final radius = maxRadius * localT;
        final opacity =
            localT < 0.15 ? localT / 0.15 : (1.0 - localT) / 0.85;
        final strokeWidth = (1.5 - r * 0.3).clamp(0.6, 1.5);
        canvas.drawCircle(
          inst.origin,
          radius,
          Paint()
            ..color = color.withAlpha((opacity.clamp(0.0, 1.0) * 180).round())
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => true;
}
