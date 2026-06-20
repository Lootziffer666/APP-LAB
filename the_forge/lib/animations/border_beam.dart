import 'package:flutter/material.dart';

/// Animated light beam sweeping the border — signals "due" or "critical" items.
/// Ported from KYUUBI. Active on items with bucket >= due.
class BorderBeam extends StatefulWidget {
  const BorderBeam({
    super.key,
    required this.child,
    required this.active,
    this.color = const Color(0xFFF97316),
    this.borderRadius = 16.0,
    this.beamWidth = 2.0,
    this.beamLength = 0.28,
    this.duration = const Duration(milliseconds: 2200),
    this.borderWidth = 1.5,
  });

  final Widget child;
  final bool active;
  final Color color;
  final double borderRadius;
  final double beamWidth;
  final double beamLength;
  final Duration duration;
  final double borderWidth;

  @override
  State<BorderBeam> createState() => _BorderBeamState();
}

class _BorderBeamState extends State<BorderBeam>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(BorderBeam old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      widget.active ? _start() : _stop();
    }
  }

  void _start() {
    final reduce = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
    if (reduce) return;
    _ctrl.repeat();
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
        foregroundPainter: _BeamPainter(
          progress: _ctrl.value,
          color: widget.color,
          borderRadius: widget.borderRadius,
          beamWidth: widget.beamWidth,
          beamLength: widget.beamLength,
          borderWidth: widget.borderWidth,
          reduceMotion: MediaQuery.of(context).disableAnimations,
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _BeamPainter extends CustomPainter {
  const _BeamPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
    required this.beamWidth,
    required this.beamLength,
    required this.borderWidth,
    required this.reduceMotion,
  });

  final double progress, borderRadius, beamWidth, beamLength, borderWidth;
  final Color color;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      borderWidth / 2, borderWidth / 2,
      size.width - borderWidth, size.height - borderWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Static dim border
    canvas.drawRRect(rrect, Paint()
      ..color = color.withAlpha(64)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth);

    if (reduceMotion) return;

    final fullPath = Path()..addRRect(rrect);
    final metrics = fullPath.computeMetrics().first;
    final total = metrics.length;
    final beamLen = total * beamLength;
    final head = (progress * total) % total;
    final tail = (head - beamLen + total) % total;

    final Path beamPath;
    if (head > tail) {
      beamPath = metrics.extractPath(tail, head);
    } else {
      beamPath = metrics.extractPath(tail, total)
        ..addPath(metrics.extractPath(0, head), Offset.zero);
    }

    canvas.drawPath(beamPath, Paint()
      ..color = color.withAlpha(230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = beamWidth
      ..strokeCap = StrokeCap.round);

    canvas.drawPath(beamPath, Paint()
      ..color = color.withAlpha(64)
      ..style = PaintingStyle.stroke
      ..strokeWidth = beamWidth * 3.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_BeamPainter old) =>
      old.progress != progress || old.reduceMotion != reduceMotion;
}
