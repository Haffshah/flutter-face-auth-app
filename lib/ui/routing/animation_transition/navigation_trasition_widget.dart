// lib/ui/routing/navigation_stack.dart
import 'package:face_match/framework/provider/network/network.dart';
import 'package:face_match/ui/routing/animation_transition/animated_page_route.dart';

class NavigationStackWidget extends StatelessWidget {
  final Widget child;
  final PageTransitionType transitionType;

  const NavigationStackWidget({super.key, required this.child, this.transitionType = PageTransitionType.slideUp});

  @override
  Widget build(BuildContext context) {
    return AnimatedPageBuilder(transitionType: transitionType, child: child);
  }
}
