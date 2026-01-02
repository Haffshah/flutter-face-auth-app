// import 'dart:async';
//
// // import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:face_match/framework/controller/auth/forgot_password_controller.dart';
// import 'package:face_match/framework/controller/auth/otp_verification_controller.dart';
// import 'package:face_match/framework/controller/auth/sign_up_controller.dart';
// import 'package:face_match/framework/provider/network/api_end_points.dart';
// import 'package:face_match/ui/routing/navigation_stack_item.dart';
// import 'package:face_match/ui/routing/stack.dart';
// import 'package:face_match/ui/utils/const/app_constants.dart';
// import 'package:face_match/ui/utils/const/app_enums.dart';
// import 'package:face_match/ui/utils/helper/base_widget.dart';
// import 'package:face_match/ui/utils/theme/app_strings.g.dart';
// import 'package:face_match/ui/utils/theme/assets.gen.dart';
// import 'package:face_match/ui/utils/theme/theme.dart';
// import 'package:face_match/ui/utils/widgets/common_appbar.dart';
// import 'package:face_match/ui/utils/widgets/common_button.dart';
// import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
// import 'package:face_match/ui/utils/widgets/common_image.dart';
// import 'package:face_match/ui/utils/widgets/common_text.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';

//
// class OtpVerificationScreen extends ConsumerStatefulWidget {
//   const OtpVerificationScreen({super.key, required this.fromScreen, required this.otpSentOn});
//
//   final FromScreen fromScreen;
//   final String otpSentOn;
//
//   @override
//   ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
//     with BaseConsumerStatefulWidget, SingleTickerProviderStateMixin {
//   /// Form Key
//   final formKey = GlobalKey<FormState>();
//
//   /// Text Editing controller
//   TextEditingController otpCtr = TextEditingController();
//
//   ///timer variable
//   late Timer timer;
//
//   /// Detect Mobile or Email From Sent On Value
//   String detectMobileOrEmail(String value) {
//     if (value.contains('@')) {
//       return LocaleKeys.keyEmail.localized;
//     } else {
//       return LocaleKeys.keyMobile.localized;
//     }
//   }
//
//   // Add animation controller and animations
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideImageAnimation;
//   late Animation<Offset> _slideTitleAnimation;
//   late Animation<Offset> _slideButtonAnimation;
//
//   /// Init Override
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       final otpVerificationWatch = ref.watch(otpVerificationController);
//       otpVerificationWatch.disposeController(isNotify: true);
//
//       timer = Timer.periodic(const Duration(seconds: 1), (_) {
//         otpVerificationWatch.otpVerifyTimer();
//       });
//     });
//   }
//
//   void _setupAnimations() {
//     _animationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
//
//     _slideImageAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );
//
//     _slideTitleAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
//       ),
//     );
//
//     _slideButtonAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   ///Dispose Override
//   @override
//   void dispose() {
//     _animationController.dispose();
//     timer.cancel();
//     super.dispose();
//   }
//
//   ///Build Override
//   @override
//   Widget buildPage(BuildContext context) {
//     final forgotPasswordWatch = ref.watch(forgotPasswordController);
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: CommonAppBar(),
//         body: _bodyWidget(),
//         bottomNavigationBar: SlideTransition(
//           position: _slideButtonAnimation,
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: CommonButton(
//               buttonText: LocaleKeys.keyVerify.localized,
//               isButtonEnabled: true,
//               isLoading:
//                   otpVerificationWatch.verifyOtpState.isLoading ||
//                   forgotPasswordWatch.forgotState.isLoading ||
//                   otpVerificationWatch.verifyPhoneApiState.isLoading ||
//                   otpVerificationWatch.verifyEmailApiState.isLoading,
//               onTap: () async {
//                 final result = formKey.currentState?.validate();
//                 if (result != null && result == true) {
//                   if (otpCtr.text.length == otpLength) {
//                     if (widget.fromScreen == FromScreen.signUp && detectMobileOrEmail(widget.otpSentOn) == 'Email') {
//                       await verifyEmailApiCall();
//                     } else if (widget.fromScreen == FromScreen.signUp &&
//                         detectMobileOrEmail(widget.otpSentOn) == 'Mobile') {
//                       await verifyPhoneApiCall();
//                     } else {
//                       await verifyOtpApiCall();
//                     }
//                   } else {
//                     showMessageDialog(context, LocaleKeys.keyPleaseEnterValidOTP.localized, () {});
//                   }
//                 }
//               },
//             ).paddingOnly(left: 30.w, right: 30.w, bottom: 10.h),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///Body Widget
//   Widget _bodyWidget() {
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     return SizedBox(
//       height: context.height,
//       width: context.width,
//       child: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 50.h),
//               // Animated Image
//               SlideTransition(
//                 position: _slideImageAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: CommonImage(strIcon: Assets.svgs.svgOtpVerification.path, height: 70.h, width: 70.h),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // Animated Title and Note
//               SlideTransition(
//                 position: _slideTitleAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         title: LocaleKeys.keySixDigitCode.localized,
//                         textStyle: TextStyles.semiBold.copyWith(fontSize: 26.sp),
//                       ).paddingOnly(bottom: 6.h),
//                       CommonText(
//                         title: '${LocaleKeys.keyOTPNote.localized}  ${widget.otpSentOn}',
//                         maxLines: 4,
//                         textStyle: TextStyles.light.copyWith(fontSize: 14.sp, color: AppColors.fontSecondaryColor),
//                       ).paddingOnly(bottom: 25.h),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // OTP Field (unchanged)
//               // Align(
//               //   alignment: Alignment.topLeft,
//               //   child: PinCodeTextField(
//               //     length: otpLength,
//               //     validator: (val) {
//               //       if (val == null || val.isEmpty) {
//               //         return LocaleKeys.keyPleaseEnterValidOTP.localized;
//               //       } else if (val.length < otpLength) {
//               //         return LocaleKeys.keyPleaseEnterValidOTP.localized;
//               //       }
//               //       return null;
//               //     },
//               //     controller: otpCtr,
//               //     autoDismissKeyboard: true,
//               //     enablePinAutofill: true,
//               //     autovalidateMode: AutovalidateMode.onUserInteraction,
//               //     pinTheme: PinTheme(
//               //       fieldHeight: 48.h,
//               //       fieldWidth: 40.h,
//               //       borderWidth: 0.4,
//               //       activeFillColor: AppColors.secondary,
//               //       shape: PinCodeFieldShape.box,
//               //       inactiveColor: AppColors.borderColor,
//               //       activeColor: AppColors.green,
//               //       borderRadius: BorderRadius.circular(10.r),
//               //     ),
//               //     keyboardType: TextInputType.number,
//               //     inputFormatters: [
//               //       FilteringTextInputFormatter.digitsOnly,
//               //     ],
//               //     textStyle: TextStyles.medium.copyWith(color: AppColors.fontPrimaryColor),
//               //     appContext: context,
//               //   ).paddingOnly(bottom: 20.h),
//               // ),
//
//               // Animated Resend Code section
//               FadeTransition(opacity: _fadeAnimation, child: _buildResendCodeSection(otpVerificationWatch)),
//             ],
//           ).paddingOnly(left: 30.w, right: 30.w),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResendCodeSection(OtpVerificationController otpVerificationWatch) {
//     return Visibility(
//       visible: otpVerificationWatch.enableResend,
//       replacement: Text(
//         otpVerificationWatch.secondsRemaining < 10
//             ? 'Resend code in 00:0${otpVerificationWatch.secondsRemaining}'
//             : 'Resend code in 00:${otpVerificationWatch.secondsRemaining}',
//         style: TextStyles.medium.copyWith(color: AppColors.fontBlack, fontSize: 16.sp),
//       ),
//       child: InkWell(
//         onTap: () async {
//           if (widget.fromScreen == FromScreen.signIn || widget.fromScreen == FromScreen.profile) {
//             await forgotPasswordApi();
//           } else {
//             await sendOtpApiCallFormSignup();
//           }
//         },
//         child: Row(
//           children: [
//             CommonImage(strIcon: Assets.images.icRefresh.path, height: 30.h, width: 30.h).paddingOnly(right: 7.w),
//             Expanded(
//               child: CommonText(
//                 title: LocaleKeys.keyResendCode.localized,
//                 textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.fontSecondaryColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Verify Otp Api Call
//   Future<void> verifyOtpApiCall() async {
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     await otpVerificationWatch.verifyOtpApi(context, email: widget.otpSentOn, otp: otpCtr.text);
//     if (otpVerificationWatch.verifyOtpState.success?.status == ApiEndPoints.apiStatus_200) {
//       showSuccessBottomSheet(
//         context: context,
//         title: LocaleKeys.keyVerificationComplete.localized,
//         subTitle: detectMobileOrEmail(widget.otpSentOn) == 'Email'
//             ? LocaleKeys.keyVerificationCompleteNoteEmail.localized
//             : LocaleKeys.keyVerificationCompleteNotePhoneNumber.localized,
//         onTap: () {
//           /// Reset Password Screen Navigation
//           ref
//               .read(navigationStackController)
//               .pushRemove(
//                 NavigationStackItem.resetPassword(
//                   email: widget.otpSentOn,
//                   otp: otpCtr.text,
//                   isForChangePassword: widget.fromScreen == FromScreen.profile,
//                 ),
//               );
//         },
//       );
//     }
//   }
//
//   /// Verify Email Api Call
//   Future<void> verifyEmailApiCall() async {
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     await otpVerificationWatch.verifyEmailApi(context, email: widget.otpSentOn, otp: otpCtr.text);
//     if (otpVerificationWatch.verifyEmailApiState.success?.status == ApiEndPoints.apiStatus_200) {
//       ref.watch(signUpController).updateIsEmailVerified(widget.otpSentOn, true);
//
//       /// Signup Screen Navigation Navigation
//       ref.read(navigationStackController).pop();
//     }
//   }
//
//   /// Verify Phone Api Call
//   Future<void> verifyPhoneApiCall() async {
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     await otpVerificationWatch.verifyPhoneApi(context, phoneNumber: widget.otpSentOn, otp: otpCtr.text);
//     if (otpVerificationWatch.verifyPhoneApiState.success?.status == ApiEndPoints.apiStatus_200) {
//       ref.watch(signUpController).updateIsPhoneVerified(widget.otpSentOn, true);
//
//       /// Signup Screen Navigation Navigation
//       ref.read(navigationStackController).pop();
//     }
//   }
//
//   /// Forgot Password Api Call
//   Future<void> forgotPasswordApi() async {
//     final forgotPasswordWatch = ref.watch(forgotPasswordController);
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     await forgotPasswordWatch.forgotPasswordApi(context, email: widget.otpSentOn);
//     if (forgotPasswordWatch.forgotState.success?.status == ApiEndPoints.apiStatus_200) {
//       /// call resend otp api
//       otpCtr.clear();
//
//       ///Start Timer again
//       FocusManager.instance.primaryFocus?.unfocus();
//       otpVerificationWatch.disposeController(isNotify: true);
//     }
//   }
//
//   /// Verify Email Api Call
//   Future<void> sendOtpApiCallFormSignup() async {
//     final otpVerificationWatch = ref.watch(otpVerificationController);
//     await otpVerificationWatch.verifyEmailApi(context, email: widget.otpSentOn, otp: '');
//     if (otpVerificationWatch.verifyOtpState.success?.status == ApiEndPoints.apiStatus_200) {
//       /// call resend otp api
//       otpCtr.clear();
//
//       ///Start Timer again
//       FocusManager.instance.primaryFocus?.unfocus();
//       otpVerificationWatch.disposeController(isNotify: true);
//     }
//   }
// }
