import 'package:face_match/ui/routing/stack.dart';
import 'package:face_match/ui/utils/theme/assets.gen.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isLeadingEnable;
  final bool isDrawerEnable;
  final GestureTapCallback? onLeadingPress;
  final GestureTapCallback? leftImageUrlClick;
  final String title;
  final String? leftImage;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? drawerColor;
  final Color? titleColor;
  final bool? centerTitle;
  final String? lottieString;
  final bool? homeScreen;
  final double? leadingWidth;
  final Widget? centerWidget;
  final TextStyle? titleTextStyle;
  final Size? appBarHeight;
  final bool isNetwork;
  final String? leftImageUrl;
  final bool forceMaterialTransparency;

  const CommonAppBar({
    super.key,
    this.isLeadingEnable = true,
    this.isDrawerEnable = false,
    this.onLeadingPress,
    this.leftImageUrlClick,
    this.leftImage,
    this.title = '',
    this.backgroundColor,
    this.titleColor,
    this.drawerColor,
    this.actions,
    this.centerWidget,
    this.centerTitle,
    this.lottieString,
    this.homeScreen,
    this.leadingWidth,
    this.titleTextStyle,
    this.appBarHeight,
    this.isNetwork = false,
    this.leftImageUrl,
    this.forceMaterialTransparency = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      forceMaterialTransparency: false,
      surfaceTintColor: backgroundColor ?? AppColors.transparent,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      foregroundColor: backgroundColor ?? AppColors.transparent,
      shadowColor: backgroundColor ?? AppColors.transparent,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth ?? 60.w,
      leading: (isLeadingEnable)
          ? InkWell(
              onTap:
                  onLeadingPress ??
                  () async {
                    if (ref.read(navigationStackController).items.length > 1) {
                      ref.read(navigationStackController).pop();
                    } else {
                      await showExitDialog(context);
                    }
                  },
              child: CommonImage(
                strIcon: leftImage != null ? leftImage! : Assets.svgs.svgBackIcon.path,
                boxFit: BoxFit.scaleDown,
                height: 46.h,
                width: 46.h,
              ).paddingAll(8.h),
            )
          : const Offstage(),
      elevation: 0,
      actions: actions,
      title:
          centerWidget ??
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleTextStyle ?? TextStyles.medium.copyWith(fontSize: 16.sp, color: titleColor ?? AppColors.textPrimary),
          ),
    );
  }

  @override
  Size get preferredSize => appBarHeight ?? Size.fromHeight(AppBar().preferredSize.height);
}

/*
Widget Usage
const CommonAppBar(
        title: LocaleKeys.keyHome.localized,
      ),
* */
