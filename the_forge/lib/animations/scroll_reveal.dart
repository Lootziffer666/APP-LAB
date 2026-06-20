import 'package:flutter/material.dart';

/// Staggered reveal animation — items slide up with a gentle fade.
/// Ported from KYUUBI. Used when list content appears or refreshes.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 340),
    this.slideOffset = 28.0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: widget.slideOffset, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) {
        if (MediaQuery.of(context).disableAnimations) {
          _ctrl.value = 1.0;
        } else {
          _ctrl.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        if (_ctrl.value >= 1.0) return child!;
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Wraps a list of widgets so each reveals with a staggered delay.
class ScrollRevealList extends StatelessWidget {
  const ScrollRevealList({
    super.key,
    required this.children,
    this.staggerMs = 55,
  });

  final List<Widget> children;
  final int staggerMs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          ScrollReveal(
            delay: Duration(milliseconds: i * staggerMs),
            child: children[i],
          ),
      ],
    );
  }
}
