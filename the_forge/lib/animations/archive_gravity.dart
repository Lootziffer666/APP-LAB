import 'package:flutter/material.dart';

/// Archive animation: item falls downward with slight rotation, fading out.
/// The "gravity-out" feel — simple, physical, final.
class ArchiveGravity extends StatefulWidget {
  const ArchiveGravity({
    super.key,
    required this.child,
    required this.animate,
    this.duration = const Duration(milliseconds: 400),
    this.onComplete,
  });

  final Widget child;
  final bool animate;
  final Duration duration;
  final VoidCallback? onComplete;

  @override
  State<ArchiveGravity> createState() => _ArchiveGravityState();
}

class _ArchiveGravityState extends State<ArchiveGravity>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fall;
  late final Animation<double> _fade;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fall = Tween(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _fade = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 1.0)),
    );
    _rotate = Tween(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onComplete?.call();
    });
    if (widget.animate) _ctrl.forward();
  }

  @override
  void didUpdateWidget(ArchiveGravity old) {
    super.didUpdateWidget(old);
    if (widget.animate && !old.animate) _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.animate ? const SizedBox.shrink() : widget.child;
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _fall.value),
        child: Transform.rotate(
          angle: _rotate.value,
          child: Opacity(opacity: _fade.value, child: child),
        ),
      ),
      child: widget.child,
    );
  }
}
