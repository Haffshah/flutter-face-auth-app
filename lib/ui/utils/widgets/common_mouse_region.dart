import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:face_match/ui/utils/theme/theme.dart';

class CustomMouseRegion extends StatelessWidget {
  final PointerEnterEventListener? onEnter;
  final PointerHoverEventListener? onHover;
  final PointerExitEventListener? onExit;
  final MouseCursor? cursor;
  final Widget child;

  const CustomMouseRegion({
    super.key,
    this.onEnter,
    this.onHover,
    this.onExit,
    this.cursor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid) {
        return child;
      }
    }
    return MouseRegion(
      onExit: onExit,
      onEnter: onEnter,
      onHover: onHover,
      cursor: cursor ?? MouseCursor.defer,
      child: child,
    );
  }
}
