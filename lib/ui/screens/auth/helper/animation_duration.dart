import 'package:flutter/animation.dart';

/// Animation durations and curves
class AnimationDurations {
  static const navigationTransition = Duration(milliseconds: 500);
  static const stepTransition = Duration(milliseconds: 600);
  static const contentFade = Duration(milliseconds: 400);
}

class AnimationCurves {
  static const stepTransition = Curves.easeInOutCubic;
  static const contentFade = Curves.easeOut;
  static const slideIn = Curves.easeOutCubic;
}
