import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';

class CommonSearchBar extends StatelessWidget with BaseStatelessWidget {
  final double? height;
  final double? width;
  final String rightIcon;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  final double? circularValue;
  final Color? clrSplash;
  final Color? clrSearchIcon;
  final Color? textColor;
  final TextStyle? hintStyle;
  final TextEditingController searchController;
  final FocusNode? focusNode;
  final double? borderRadius;
  final String hintText;
  final String leftIcon;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Function()? onClearSearch;
  final Color? borderColor;
  final Color? bgColor;
  final Color? cursorColor;
  final double? borderWidth;
  final ValueChanged<String>? onFieldSubmitted;

  const CommonSearchBar({
    super.key,
    required this.searchController,
    this.onTap,
    this.onClearSearch,
    this.height,
    this.width,
    this.rightIcon = '',
    this.leftIcon = '',
    this.onChanged,
    this.circularValue,
    this.clrSplash,
    this.clrSearchIcon,
    this.textColor,
    this.borderRadius,
    this.focusNode,
    this.hintText = '',
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.cursorColor,
    this.onFieldSubmitted,
    this.leftWidget,
    this.rightWidget,
    this.hintStyle,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        border: Border.all(color: borderColor ?? AppColors.transparent, width: (borderWidth ?? 0.5).w),
      ),
      width: width ?? double.infinity,
      constraints: BoxConstraints(maxHeight: height ?? 48.h),
      height: height ?? 48.h,
      child: InkWell(
        splashColor: clrSplash ?? AppColors.primary.withAlpha(75),
        borderRadius: BorderRadius.circular(circularValue ?? 7.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 0.w),
          child: Center(
            child: TextFormField(
              controller: searchController,
              focusNode: focusNode,
              cursorColor: cursorColor ?? AppColors.primary,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyles.regular.copyWith(color: textColor ?? AppColors.textPrimary, fontSize: 13.sp),
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              maxLines: 1,
              onTapOutside: (v) {
                hideKeyboard(context);
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                hintStyle: hintStyle ?? TextStyles.light.copyWith(color: AppColors.fontSecondaryColor, fontSize: 13.sp),
                prefixIcon: (leftIcon.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 16.w),
                        child: CommonImage(
                          strIcon: leftIcon,
                          boxFit: BoxFit.scaleDown,
                          height: 18.h,
                          width: 18.w,
                          imgColor: clrSearchIcon ?? AppColors.primary,
                        ),
                      )
                    : leftWidget ?? const Offstage(),
                prefixIconConstraints: BoxConstraints(minHeight: 10.h, minWidth: 20.w),
                hintText: hintText,
                suffixIcon: InkWell(
                    onTap: () {
                      onClearSearch?.call();
                    },
                    child: (rightIcon.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 16.w),
                            child: CommonImage(
                              strIcon: rightIcon,
                              boxFit: BoxFit.scaleDown,
                              height: 18.h,
                              width: 18.w,
                              imgColor: clrSearchIcon ?? AppColors.primary,
                            ),
                          )
                        : rightWidget ?? const Offstage()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*  Widget Usage
*
CommonSearchBar(leftIcon: AppAssets.svgDrawerMenu, controller: txtSearch)
* */
