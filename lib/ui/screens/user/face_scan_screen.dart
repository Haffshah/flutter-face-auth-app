import 'package:face_match/framework/controller/user/face_match_controller.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_appbar.dart';
import 'package:face_match/ui/utils/widgets/common_button.dart';
import 'package:face_match/ui/utils/widgets/common_card.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';


final faceMatchControllerProvider = ChangeNotifierProvider.autoDispose<FaceMatchController>(
  (ref) => getIt<FaceMatchController>(),
);

class FaceScanScreen extends ConsumerStatefulWidget {
  const FaceScanScreen({super.key});

  @override
  ConsumerState<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends ConsumerState<FaceScanScreen> with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(faceMatchControllerProvider).init();
    });
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    final controller = ref.watch(faceMatchControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: LocaleKeys.keyFaceScanMatch.localized,
        centerTitle: true,
        titleTextStyle: TextStyles.bold.copyWith(fontSize: 20.sp, color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),

            // Scan Illustration Card
            CommonCard(
              elevation: 4,
              cornerRadius: 20.r,
              color: AppColors.primary.withAlpha(13),
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withAlpha(51), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Icon(Icons.face_retouching_natural, size: 80.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: 20.h),
                    CommonText(
                      title: LocaleKeys.keyFaceRecognition.localized,
                      textStyle: TextStyles.bold.copyWith(fontSize: 20.sp, color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    CommonText(
                      title: LocaleKeys.keyScanAFaceToIdentifyRegisteredUsers.localized,
                      textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Match Result Card
            if (controller.matchedUser != null)
              CommonCard(
                elevation: 3,
                cornerRadius: 20.r,
                color: AppColors.backgroundCard,
                borderColor: AppColors.success,
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // Success Icon
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(color: AppColors.success.withAlpha(26), shape: BoxShape.circle),
                        child: Icon(Icons.check_circle, size: 48.sp, color: AppColors.success),
                      ),
                      SizedBox(height: 20.h),

                      // User Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.success.withAlpha(128), width: 3.w),
                          boxShadow: [
                            BoxShadow(color: AppColors.success.withAlpha(51), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipOval(
                          child: CommonImage(
                            strIcon: controller.matchedUser!.imagePath,
                            isFileImage: true,
                            height: 100.h,
                            width: 100.h,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Match Success Title
                      CommonText(
                        title: LocaleKeys.keyMatchFound.localized,
                        textStyle: TextStyles.bold.copyWith(fontSize: 22.sp, color: AppColors.success),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),

                      // User Name
                      CommonText(
                        title: controller.matchedUser!.name,
                        textStyle: TextStyles.bold.copyWith(fontSize: 18.sp, color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),

                      // User ID
                      CommonText(
                        title: 'User ID: ${controller.matchedUser!.id}',
                        textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),

                      // Confidence Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(26),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 18.sp, color: AppColors.success),
                            SizedBox(width: 8.w),
                            CommonText(
                              title: 'Confidence: ${(controller.confidence! * 100).toStringAsFixed(1)}%',
                              textStyle: TextStyles.semiBold.copyWith(fontSize: 14.sp, color: AppColors.success),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // No Match State
              CommonCard(
                elevation: 2,
                cornerRadius: 16.r,
                color: AppColors.textSecondary.withAlpha(26),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Icon(Icons.center_focus_strong, size: 60.sp, color: AppColors.textSecondary),
                      SizedBox(height: 16.h),
                      CommonText(
                        title: LocaleKeys.keyReadyToScan.localized,
                        textStyle: TextStyles.semiBold.copyWith(fontSize: 16.sp, color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      CommonText(
                        title: LocaleKeys.keyClickTheButtonBelowToStartFaceScanning.localized,
                        textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 32.h),

            // Status Card (if initializing)
            if (!controller.isInitialized)
              CommonCard(
                elevation: 2,
                cornerRadius: 12.r,
                color: AppColors.primary.withAlpha(26),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CommonText(
                          title: LocaleKeys.keyInitializingFaceSdk.localized,
                          textStyle: TextStyles.medium.copyWith(fontSize: 13.sp, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 24.h),

            // Scan Button
            CommonButton(
              buttonText: controller.isProcessing ? 'Scanning...' : 'Start Face Scan',
              isLoading: controller.isProcessing,
              isButtonEnabled: controller.isInitialized && !controller.isProcessing,
              buttonEnabledColor: AppColors.primary,
              buttonDisabledColor: AppColors.textSecondary.withAlpha(128),
              height: 56.h,
              leftIcon: !controller.isProcessing
                  ? Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(Icons.face_retouching_natural, color: AppColors.white, size: 20.sp),
                    )
                  : null,
              onTap: () {
                controller.onScan(_showSnackBar);
              },
            ),

            SizedBox(height: 16.h),

            // Info Card
            CommonCard(
              elevation: 1,
              cornerRadius: 12.r,
              color: AppColors.textSecondary.withAlpha(26),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CommonText(
                        title: LocaleKeys.keyPositionYourFaceInTheCameraFrameAndHoldStillForBestResults.localized,
                        textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: AppColors.textSecondary),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
