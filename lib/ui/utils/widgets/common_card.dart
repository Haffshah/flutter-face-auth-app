import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonCard extends StatelessWidget with BaseStatelessWidget {
  final double? elevation;
  final Color? shadowColor;
  final Color? color;
  final Widget child;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final double? cornerRadius;
  final Color? borderColor;

  const CommonCard({
    super.key,
    required this.child,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.margin,
    this.cornerRadius,
    this.color,
    this.borderColor,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
      shadowColor: shadowColor ?? AppColors.grey.withAlpha(26),
      color: color ?? AppColors.backgroundCard,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius ?? 20.r),
            side: BorderSide(color: borderColor ?? AppColors.transparent),
          ),
      margin: margin,
      child: child,
    );
  }
}
