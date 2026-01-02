// lib/ui/routing/animated_page_builder.dart
import 'package:flutter/material.dart';

enum PageTransitionType { fade, slideUp, slideLeft, scale, none }

class AnimatedPageBuilder extends StatelessWidget {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  const AnimatedPageBuilder({
    super.key,
    required this.child,
    this.transitionType = PageTransitionType.slideUp,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return PageTransitionBuilder(
      duration: duration,
      curve: curve,
      type: transitionType,
      child: child,
    );
  }
}

class PageTransitionBuilder extends StatelessWidget {
  final Widget child;
  final PageTransitionType type;
  final Curve curve;
  final Duration duration;

  const PageTransitionBuilder({
    super.key,
    required this.child,
    required this.type,
    required this.curve,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        switch (type) {
          case PageTransitionType.fade:
            return Opacity(
              opacity: value,
              child: child,
            );

          case PageTransitionType.slideUp:
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case PageTransitionType.slideLeft:
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case PageTransitionType.scale:
            return Transform.scale(
              scale: 0.95 + (0.05 * value),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case PageTransitionType.none:
            return child!;
        }
      },
      child: child,
    );
  }
}


