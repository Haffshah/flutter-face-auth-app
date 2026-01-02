import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';

class CommonCheckBox extends StatelessWidget with BaseStatelessWidget {
  const CommonCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.shape,
    this.fillColor,
    this.selectedBorder,
    this.unSelectedBorder,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? fillColor;
  final Color? selectedBorder;
  final Color? unSelectedBorder;
  final OutlinedBorder? shape;

  @override
  Widget buildPage(BuildContext context) {
    return Checkbox(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(3.r),
              bottomRight: Radius.circular(3.r),
            ),
          ),
      fillColor: WidgetStatePropertyAll(fillColor),
      activeColor: activeColor ?? AppColors.backgroundCard,
      checkColor: checkColor ?? AppColors.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: WidgetStateBorderSide.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(
              color: selectedBorder ?? AppColors.transparent,
              width: 1.w,
            );
          } else {
            return BorderSide(
              color: unSelectedBorder ?? AppColors.transparent,
              width: 1.w,
            );
          }
        },
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
