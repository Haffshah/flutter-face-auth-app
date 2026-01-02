import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/framework/utils/local_storage/session.dart';
import 'package:face_match/ui/utils/anim/fade_box_transition.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';
import 'package:face_match/ui/utils/theme/assets.gen.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_button.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';

void showSuccessDialogue({
  required BuildContext context,
  required String animation,
  required String successMessage,
  String? successDescription,
  required String buttonText,
  void Function()? onTap,
}) {
  showDialog(
    context: context,
    barrierColor: AppColors.grey.withAlpha(125),
    barrierDismissible: false,
    builder: (context) {
      return FadeBoxTransition(
        child: Dialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          surfaceTintColor: AppColors.backgroundCard,
          backgroundColor: AppColors.backgroundCard,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: Consumer(builder: (context, ref, child) {
              return Column(
                children: [
                  // const Spacer(),
                  // Lottie.asset(
                  //   animation,
                  //   height: MediaQuery.sizeOf(context).height * 0.3,
                  //   width: MediaQuery.sizeOf(context).width * 0.3,
                  //   fit: BoxFit.contain,
                  //   repeat: true,
                  // ),
                  Text(
                    successMessage,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium.copyWith(fontSize: 18.sp, color: AppColors.black),
                  ),
                  const Spacer(),
                  if (successDescription?.isNotEmpty ?? false)
                    Text(
                      successDescription!,
                      textAlign: TextAlign.center,
                      style: TextStyles.regular.copyWith(color: AppColors.black),
                    ),
                  const Spacer(),
                  CommonButton(
                    buttonText: buttonText,
                    buttonTextStyle: TextStyles.regular.copyWith(color: AppColors.white),
                    height: 50.h,
                    width: 200.w,
                    buttonEnabledColor: AppColors.primary,
                    isButtonEnabled: true,
                    onTap: onTap,
                  ),
                  const Spacer(),
                ],
              );
            }),
          ),
        ),
      );
    },
  );
}

/// Confirmation dialog  message
Future showConfirmationDialog(
  BuildContext context,
  String title,
  String message,
  String btn1Name,
  String btn2Name,
  Function(bool isPositive) didTakeAction, {
  bool barrierDismissible = true,
}) {
  return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      barrierColor: AppColors.grey.withAlpha(125),
      builder: (context) => FadeBoxTransition(
            child: Dialog(
              backgroundColor: AppColors.backgroundCard,
              surfaceTintColor: AppColors.backgroundCard,
              insetPadding: EdgeInsets.all(16.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 22.h, bottom: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        message == '' ? SizedBox(height: 20.h) : const SizedBox(),
                        CommonText(
                            title: title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            textStyle: TextStyles.semiBold.copyWith(color: AppColors.textPrimary, fontSize: 18.sp)),
                        message != '' ? SizedBox(height: 10.h) : const SizedBox(),
                        CommonText(
                            title: message,
                            maxLines: 100,
                            textAlign: TextAlign.center,
                            textStyle:
                                TextStyles.regular.copyWith(color: AppColors.textSecondary, fontSize: 16.sp)),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonButton(
                                width: 139.w,
                                height: 49.h,
                                isButtonEnabled: true,
                                buttonText: btn1Name,
                                borderRadius: BorderRadius.circular(30.r),
                                borderWidth: 1.w,
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(const Duration(milliseconds: 80), () {
                                    didTakeAction(true);
                                  });
                                },
                                borderColor: AppColors.primary,
                                buttonEnabledColor: AppColors.white,
                                buttonTextColor: AppColors.primary),
                            SizedBox(width: 15.w),
                            CommonButton(
                                buttonText: btn2Name,
                                width: 139.w,
                                height: 49.h,
                                borderWidth: 1.w,
                                isButtonEnabled: true,
                                borderRadius: BorderRadius.circular(30.r),
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(const Duration(milliseconds: 80), () {
                                    didTakeAction(false);
                                  });
                                },
                                borderColor: AppColors.primary,
                                buttonEnabledColor: AppColors.primary,
                                buttonTextColor: AppColors.white),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
}

Future showSuccessDialog(BuildContext context, String title, String message, Function()? didDismiss, {IconData? icon}) {
  if (didDismiss != null) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      didDismiss();
    });
  }
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.grey.withAlpha(125),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.backgroundCard,
        surfaceTintColor: AppColors.backgroundCard,
        insetPadding: EdgeInsets.all(16.sp),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.check_circle, size: 130.sp, color: AppColors.green).paddingOnly(bottom: 20.h),
              title != ''
                  ? CommonText(
                      title: title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textStyle: TextStyles.semiBold.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 22.sp,
                      ),
                    ).paddingOnly(bottom: 20.h)
                  : const Offstage(),
              CommonText(
                title: message,
                textAlign: TextAlign.center,
                maxLines: 10,
                textStyle: TextStyles.medium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    ),
  );
}

GlobalKey errorDialogKey = GlobalKey();

dynamic showCommonErrorDialog({
  required BuildContext context,
  required String message,
  TextStyle? textStyle,
  Function()? onButtonTap,
  double? height,
  double? width,
}) {
  if (errorDialogKey.currentState == null && errorDialogKey.currentContext == null) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: AppColors.grey.withAlpha(125),
        builder: (context) {
          return FadeBoxTransition(
            child: AlertDialog(
              key: errorDialogKey,
              backgroundColor: AppColors.backgroundCard,
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Builder(builder: (BuildContext context) {
                return SizedBox(
                  width: width ?? context.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            message,
                            style: textStyle ?? TextStyles.medium.copyWith(color: AppColors.primary, fontSize: 16.sp),
                            maxLines: 10,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ).paddingOnly(bottom: 30),
                      CommonButton(
                        height: 45,
                        width: 100,
                        buttonText: LocaleKeys.keyOk.localized,
                        isButtonEnabled: true,
                        onTap: onButtonTap ??
                            () {
                              Navigator.of(context).pop();
                            },
                      )
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}

Future showLoadingDialogWeb({
  GlobalKey? key,
  required BuildContext context,
  required String title,
  bool isDismissible = true,
  String message = '',
  double? dialogWidth,
  double? titleFontSize,
  double? messageFontSize,
  bool? isLoading,
}) {
  return showDialog(
      barrierDismissible: isDismissible,
      context: context,
      barrierColor: AppColors.grey.withAlpha(125),
      builder: (BuildContext context) {
        return Dialog(
          key: key,
          surfaceTintColor: AppColors.backgroundCard,
          backgroundColor: AppColors.backgroundCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: SizedBox(
            width: dialogWidth,
            height: context.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: context.height * 0.01),
                if (title.isNotEmpty)
                  CommonText(
                    title: title,
                    fontSize: context.height * 0.026,
                    clrfont: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                if (message.isNotEmpty)
                  CommonText(
                    title: message,
                    fontSize: context.height * 0.020,
                    clrfont: AppColors.textPrimary,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: context.height * 0.005),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.030, vertical: context.height * 0.030),
          ),
        );
      });
}

/// Widget Dialog
void showWidgetDialog(
  BuildContext context,
  Widget? widget,
  Function()? didDismiss, {
  bool isDismissDialog = true,
  int autoDismissTimer = 0,
  GlobalKey? dialogKey,
}) {
  showDialog(
    barrierDismissible: isDismissDialog,
    context: context,
    barrierColor: AppColors.grey.withAlpha(125),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        key: dialogKey,
        surfaceTintColor: AppColors.backgroundCard,
        backgroundColor: AppColors.backgroundCard,
        insetPadding: EdgeInsets.all(25.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20.r)),
        ),
        child: Wrap(
          children: [widget!],
        ),
      ),
    ),
  );

  if (autoDismissTimer > 0) {
    Future.delayed(Duration(seconds: autoDismissTimer), () {
      if (didDismiss != null) {
        didDismiss();
      }
    });
  } else {
    if (isDismissDialog) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        didDismiss!();
      });
    }
  }
}

/// Message Dialog
dynamic showMessageDialog(BuildContext context, String message, Function()? didDismiss,
    {String? title, String? buttonText}) {
  if (message == '') return;
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.grey.withAlpha(125),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.backgroundCard,
        surfaceTintColor: AppColors.backgroundCard,
        insetPadding: EdgeInsets.all(16.sp),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? CommonText(
                      title: title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textStyle: TextStyles.bold.copyWith(color: AppColors.textPrimary, fontSize: 22.sp),
                    ).paddingOnly(bottom: 10.h)
                  : const Offstage(),
              CommonText(
                title: message,
                textAlign: TextAlign.center,
                maxLines: 5,
                textStyle: TextStyles.medium.copyWith(color: AppColors.textSecondary, fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              CommonButton(
                buttonTextColor: AppColors.white,
                isButtonEnabled: true,
                buttonEnabledColor: AppColors.primary,
                borderColor: AppColors.primary,
                width: 150.w,
                buttonText: buttonText ?? LocaleKeys.keyOk.localized,
                onTap: () {
                  Navigator.pop(context);
                  if (didDismiss != null) {
                    Future.delayed(
                      const Duration(milliseconds: 80),
                      () {
                        didDismiss();
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

/// Logout Dialog
void showLogoutDialog(BuildContext context, WidgetRef ref) {
  showConfirmationDialog(context, LocaleKeys.keyLogout.localized, LocaleKeys.keyLogoutConfirmationMessageWeb.localized,
      LocaleKeys.keyLogout.localized, LocaleKeys.keyCancel.localized, (isPositive) {
    if (isPositive) {
      SessionHelper.sessionLogout(ref);
    }
  });
}

/// Session Expired Dialog
Future sessionExpiredDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.grey.withAlpha(125),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        return Dialog(
          backgroundColor: AppColors.backgroundCard,
          surfaceTintColor: AppColors.backgroundCard,
          insetPadding: EdgeInsets.all(16.sp),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: CommonText(
                          title: LocaleKeys.keyYourSessionExpiredNote.localized,
                          textAlign: TextAlign.center,
                          maxLines: 10,
                          textStyle: TextStyles.medium.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CommonButton(
                        buttonTextColor: AppColors.white,
                        buttonEnabledColor: AppColors.primary,
                        isButtonEnabled: true,
                        borderColor: AppColors.primary,
                        width: 150.w,
                        buttonText: LocaleKeys.keySignIn.localized,
                        onTap: () {
                          Navigator.pop(context);
                          SessionHelper.sessionLogout(ref);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Exit DialogBox
dynamic showExitDialog(BuildContext context) {
  return showConfirmationDialog(
      context,
      LocaleKeys.keyExit.localized,
      LocaleKeys.keyAreYouSureWantToExitFromApp.localized,
      LocaleKeys.keyExit.localized,
      LocaleKeys.keyCancel.localized, (isPositive) {
    if (isPositive) {
      exit(0);
    }
  });
}

///
void showSuccessBottomSheet({
  required BuildContext context,
  required String title,
  required String subTitle,
  required Function onTap,
  bool isButtonRequired = false,
  String buttonText = '',
}) {
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pop(context);
    onTap.call();
  });
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return FadeBoxTransition(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.h),
                CommonImage(
                  strIcon: Assets.images.icSuccess.path,
                  height: 65.h,
                  width: 65.h,
                ).paddingOnly(bottom: 13.h),
                CommonText(
                  title: title,
                  textAlign: TextAlign.center,
                  textStyle: TextStyles.bold.copyWith(fontSize: 18.sp),
                ).paddingOnly(bottom: 10.h),
                CommonText(
                  title: subTitle,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  textStyle: TextStyles.regular.copyWith(fontSize: 13.sp, color: AppColors.clr7B7E91),
                ),
                SizedBox(height: 40.h),
                if (buttonText != '' && isButtonRequired)
                  CommonButton(
                    isButtonEnabled: true,
                    isLoading: false,
                    buttonEnabledColor: AppColors.secondary,
                    buttonTextColor: AppColors.textPrimary,
                    buttonText: buttonText,
                    onTap: () {
                      Navigator.pop(context);
                      onTap.call();
                    },
                  ),
                SizedBox(height: 30.h)
              ],
            ),
          ),
        );
      });
}

void showConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  required String subTitle,
  String? btn1Name,
  String? btn2Name,
  required Function(bool isPositive) didTakeAction,
}) {
  // if (onTap != null) {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Navigator.pop(context);
  //     onTap.call();
  //   });
  // }
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: FadeBoxTransition(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  CommonImage(
                    strIcon: Assets.images.icSuccess.path,
                    height: 65.h,
                    width: 65.h,
                  ).paddingOnly(bottom: 13.h),
                  CommonText(
                    title: title,
                    textStyle: TextStyles.bold.copyWith(fontSize: 18.sp),
                  ).paddingOnly(bottom: 10.h),
                  CommonText(
                    title: subTitle,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: TextStyles.regular.copyWith(fontSize: 13.sp, color: AppColors.clr7B7E91),
                  ).paddingOnly(left: 20.w, right: 20.w),
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          isButtonEnabled: true,
                          isLoading: false,
                          buttonEnabledColor: AppColors.secondary,
                          buttonTextStyle: TextStyles.regular.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.clr1A1A1A,
                          ),
                          buttonText: btn1Name ?? LocaleKeys.keyCancel.localized,
                          onTap: () {
                            Navigator.pop(context);
                            didTakeAction.call(false);
                          },
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: CommonButton(
                          isButtonEnabled: true,
                          isLoading: false,
                          buttonEnabledColor: AppColors.primary,
                          buttonTextColor: AppColors.textPrimary,
                          buttonTextStyle: TextStyles.regular.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                          buttonText: btn2Name ?? LocaleKeys.keyYes.localized,
                          onTap: () {
                            Navigator.pop(context);
                            didTakeAction.call(true);
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 20.w, right: 20.w),
                  SizedBox(height: 30.h)
                ],
              ),
            ),
          ),
        );
      });
}
