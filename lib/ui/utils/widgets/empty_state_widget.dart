import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';


class EmptyStateWidget extends StatelessWidget with BaseStatelessWidget {
  final IconData? icon;
  final String? title;
  final String? description;
  final double? iconSize;
  final Widget? buttonWidget;

  const EmptyStateWidget({super.key, this.icon, this.title, this.description, this.iconSize, this.buttonWidget});

  @override
  Widget buildPage(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Premium Icon Container
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(10), blurRadius: 40, spreadRadius: 10)],
              ),
              child: Icon(icon ?? Icons.group_off_outlined, size: iconSize ?? 60.sp, color: AppColors.primary),
            ),

            SizedBox(height: 32.h),

            // Title
            CommonText(
              title: title ?? LocaleKeys.keyNoDataFound.localized,
              textAlign: TextAlign.center,
              textStyle: TextStyles.bold.copyWith(fontSize: 22.sp, color: AppColors.textPrimary, letterSpacing: 0.5),
            ),

            SizedBox(height: 12.h),

            // Description
            CommonText(
              title: description ?? LocaleKeys.keyTheRecordsAppearEmptyRightNow.localized,
              textAlign: TextAlign.center,
              maxLines: 3,
              textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.textSecondary, height: 1.5),
            ),

            if (buttonWidget != null) ...[SizedBox(height: 32.h), buttonWidget!],
          ],
        ),
      ),
    );
  }
}
