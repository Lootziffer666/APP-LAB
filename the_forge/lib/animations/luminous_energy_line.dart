import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated energy line along the bottom edge — signals urgency level.
/// Ported from KYUUBI. Maps directly to engine buckets via ForgeDesignBridge.
enum LuminousMode { calm, pressure, urgent, pulse }

class LuminousEnergyLine extends StatefulWidget {
  const LuminousEnergyLine({
    super.key,
    required this.child,
    required this.active,
    this.mode = LuminousMode.calm,
    this.lineWidth = 2.5,
    this.glowWidth = 8.0,
  });

  final Widget child;
  final bool active;
  final LuminousMode mode;
  final double lineWidth;
  final double glowWidth;

  @override
  State<LuminousEnergyLine> createState() => _LuminousEnergyLineState();
}

class _LuminousEnergyLineState extends State<LuminousEnergyLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  Duration get _duration => switch (widget.mode) {
        LuminousMode.calm => const Duration(milliseconds: 3200),
        LuminousMode.pressure => const Duration(milliseconds: 1800),
        LuminousMode.urgent => const Duration(milliseconds: 800),
        LuminousMode.pulse => const Duration(milliseconds: 1200),
      };

  Color get _color => switch (widget.mode) {
        LuminousMode.calm => const Color(0xFF3EC4D0),
        LuminousMode.pressure => const Color(0xFFF97316),
        LuminousMode.urgent => const Color(0xFFFF5757),
        LuminousMode.pulse => const Color(0xFF8B9FE8),
      };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration);
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(LuminousEnergyLine old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active || widget.mode != old.mode) {
      _ctrl.duration = _duration;
      widget.active ? _start() : _stop();
    }
  }

  void _start() {
    final reduce = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
    if (reduce) return;
    if (widget.mode == LuminousMode.pulse) {
      _ctrl.forward(from: 0);
    } else {
      _ctrl.repeat();
    }
  }

  void _stop() {
    _ctrl.stop();
    _ctrl.reset();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => CustomPaint(
        foregroundPainter: _LinePainter(
          progress: _ctrl.value,
          color: _color,
          mode: widget.mode,
          lineWidth: widget.lineWidth,
          glowWidth: widget.glowWidth,
          reduceMotion: MediaQuery.of(context).disableAnimations,
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({
    required this.progress,
    required this.color,
    required this.mode,
    required this.lineWidth,
    required this.glowWidth,
    required this.reduceMotion,
  });

  final double progress;
  final Color color;
  final LuminousMode mode;
  final double lineWidth, glowWidth;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, size.height);
    final p2 = Offset(size.width, size.height);

    if (reduceMotion) {
      canvas.drawLine(p1, p2, Paint()
        ..color = color.withAlpha(128)
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round);
      return;
    }

    // Base line
    canvas.drawLine(p1, p2, Paint()
      ..color = color.withAlpha(38)
      ..strokeWidth = lineWidth * 0.5
      ..strokeCap = StrokeCap.round);

    // Moving segment
    final t = mode == LuminousMode.urgent
        ? (math.sin(progress * 2 * math.pi) + 1) / 2
        : progress;
    const segLen = 0.60;
    final segStart = (t - segLen).clamp(0.0, 1.0);
    final pStart = Offset.lerp(p1, p2, segStart)!;
    final pEnd = Offset.lerp(p1, p2, t)!;

    // Glow
    canvas.drawLine(pStart, pEnd, Paint()
      ..color = color.withAlpha(90)
      ..strokeWidth = glowWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowWidth * 0.6));

    // Core
    canvas.drawLine(pStart, pEnd, Paint()
      ..color = color.withAlpha(220)
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round);

    // Bright tip
    canvas.drawCircle(pEnd, lineWidth * 1.2, Paint()
      ..color = Colors.white.withAlpha(180));
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.progress != progress;
}
