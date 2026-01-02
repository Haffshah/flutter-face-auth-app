// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:face_match/framework/controller/auth/reset_password_controller.dart';
// import 'package:face_match/framework/provider/network/api_end_points.dart';
// import 'package:face_match/framework/utils/extension/context_extension.dart';
// import 'package:face_match/framework/utils/extension/extension.dart';
// import 'package:face_match/framework/utils/extension/string_extension.dart';
// import 'package:face_match/ui/routing/navigation_stack_item.dart';
// import 'package:face_match/ui/routing/stack.dart';
// import 'package:face_match/ui/utils/const/app_constants.dart';
// import 'package:face_match/ui/utils/const/form_validations.dart';
// import 'package:face_match/ui/utils/helper/base_widget.dart';
// import 'package:face_match/ui/utils/theme/app_colors.dart';
// import 'package:face_match/ui/utils/theme/app_strings.g.dart';
// import 'package:face_match/ui/utils/theme/assets.gen.dart';
// import 'package:face_match/ui/utils/theme/text_style.dart';
// import 'package:face_match/ui/utils/widgets/common_appbar.dart';
// import 'package:face_match/ui/utils/widgets/common_button.dart';
// import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
// import 'package:face_match/ui/utils/widgets/common_form_field.dart';
// import 'package:face_match/ui/utils/widgets/common_image.dart';
// import 'package:face_match/ui/utils/widgets/common_text.dart';
//
// class ResetPasswordScreen extends ConsumerStatefulWidget {
//   const ResetPasswordScreen({super.key, required this.email, required this.otp, required this.isForChangePassword});
//
//   final String email;
//   final String otp;
//   final bool isForChangePassword;
//
//   @override
//   ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
//     with BaseConsumerStatefulWidget, SingleTickerProviderStateMixin {
//   /// Form Key
//   final formKey = GlobalKey<FormState>();
//
//   /// Text Editing Controller
//   TextEditingController currentPassCtr = TextEditingController();
//   TextEditingController newPassCtr = TextEditingController();
//   TextEditingController confirmPassCtr = TextEditingController();
//
//   /// Animation controller and animations
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideIconAnimation;
//   late Animation<Offset> _slideTitleAnimation;
//   late Animation<Offset> _slideFormAnimation;
//   late Animation<Offset> _slideValidationAnimation;
//   late Animation<Offset> _slideButtonAnimation;
//
//   ///Init Override
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       final resetPasswordWatch = ref.watch(resetPasswordController);
//       resetPasswordWatch.disposeController(isNotify: true);
//       newPassCtr.addListener(validatePasswordFields);
//       confirmPassCtr.addListener(validatePasswordFields);
//       if (widget.isForChangePassword) {
//         currentPassCtr.addListener(validatePasswordFields);
//       }
//     });
//   }
//
//   void _setupAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     ));
//
//     _slideIconAnimation = Tween<Offset>(
//       begin: const Offset(-1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
//     ));
//
//     _slideTitleAnimation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
//     ));
//
//     _slideFormAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
//     ));
//
//     _slideValidationAnimation = Tween<Offset>(
//       begin: const Offset(-1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
//     ));
//
//     _slideButtonAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 1.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
//     ));
//
//     _animationController.forward();
//   }
//
//   final ValueNotifier<Map<String, bool>> validationState = ValueNotifier({
//     'minLength': false,
//     'number': false,
//     'symbol': false,
//   });
//
//   /// Check Based on All Validation
//   void validatePasswordFields() {
//     String password1 = newPassCtr.text;
//     String password2 = confirmPassCtr.text;
//     String password3 = currentPassCtr.text;
//
//     if (widget.isForChangePassword) {
//       bool bothHaveMinLength = password1.length >= 8 && password2.length >= 8 && password3.length >= 8;
//       bool bothHaveNumber =
//           RegExp(r'\d').hasMatch(password1) && RegExp(r'\d').hasMatch(password2) && RegExp(r'\d').hasMatch(password3);
//       bool bothHaveSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password1) &&
//           RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password2) &&
//           RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password3);
//
//       validationState.value = {
//         'minLength': bothHaveMinLength,
//         'number': bothHaveNumber,
//         'symbol': bothHaveSymbol,
//       };
//     } else {
//       bool bothHaveMinLength = password1.length >= 8 && password2.length >= 8;
//       bool bothHaveNumber = RegExp(r'\d').hasMatch(password1) && RegExp(r'\d').hasMatch(password2);
//       bool bothHaveSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password1) &&
//           RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password2);
//
//       validationState.value = {
//         'minLength': bothHaveMinLength,
//         'number': bothHaveNumber,
//         'symbol': bothHaveSymbol,
//       };
//     }
//   }
//
//   ///Dispose Override
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     validationState.dispose();
//     super.dispose();
//   }
//
//   ///Build Override
//   @override
//   Widget buildPage(BuildContext context) {
//     final resetPasswordWatch = ref.watch(resetPasswordController);
//
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
//               buttonText: widget.isForChangePassword
//                   ? LocaleKeys.keyChangePassword.localized
//                   : LocaleKeys.keyResetPassword.localized,
//               isButtonEnabled: true,
//               isLoading:
//                   resetPasswordWatch.resetPasswordState.isLoading/* || resetPasswordWatch.changePasswordState.isLoading*/,
//               onTap: () async {
//                 final result = formKey.currentState?.validate();
//                 if (result != null && result == true) {
//                   if (widget.isForChangePassword) {
//                     await changePasswordApiCall();
//                   } else {
//                     await resetPasswordApiCall();
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
//     final resetPasswordWatch = ref.watch(resetPasswordController);
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
//
//               // Animated Icon
//               SlideTransition(
//                 position: _slideIconAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: CommonImage(
//                     strIcon: Assets.svgs.svgResetPasword.path,
//                     height: 70.h,
//                     width: 70.h,
//                   ),
//                 ),
//               ).paddingOnly(bottom: 15.h),
//
//               // Animated Title and Description
//               SlideTransition(
//                 position: _slideTitleAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         title: LocaleKeys.keyUpdateYourNewPassword.localized,
//                         maxLines: 2,
//                         textStyle: TextStyles.semiBold.copyWith(fontSize: 26.sp),
//                       ).paddingOnly(bottom: 10.h),
//                       CommonText(
//                         title: LocaleKeys.keySetNewPasswordNote.localized,
//                         maxLines: 4,
//                         textStyle: TextStyles.light.copyWith(
//                           fontSize: 14.sp,
//                           color: AppColors.fontSecondaryColor,
//                         ),
//                       ).paddingOnly(bottom: 25.h),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Animated Form Fields
//               SlideTransition(
//                 position: _slideFormAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     children: [
//                       // Current Password Field
//                       if (widget.isForChangePassword)
//
//                         /// Current Password
//                         Visibility(
//                           visible: widget.isForChangePassword,
//                           child: CommonInputFormField(
//                             textEditingController: currentPassCtr,
//                             maxLines: 1,
//                             textInputType: TextInputType.text,
//                             obscureText: !resetPasswordWatch.isShowCurrentPassword,
//                             textInputAction: TextInputAction.next,
//                             maxLength: maxPasswordLength,
//                             suffixWidget: InkWell(
//                               onTap: () {
//                                 resetPasswordWatch.updateIsShowCurrentPassword();
//                               },
//                               child: CommonImage(
//                                 strIcon: !resetPasswordWatch.isShowCurrentPassword
//                                     ? Assets.svgs.svgPasswordEye.path
//                                     : Assets.svgs.svgHidePaswordEye.path,
//                                 boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                                 height: context.isTablet ? 24.h : 20.h,
//                                 width: context.isTablet ? 24.h : 20.h,
//                               ),
//                             ).paddingOnly(right: 10.w),
//                             validator: (v) {
//                               if (widget.isForChangePassword) {
//                                 return validatePassword(
//                                     value: v, forPass: false, forCurrentPass: true, changePassword: false);
//                               } else {
//                                 return null;
//                               }
//                             },
//                             hintText: LocaleKeys.keyCurrentPassword.localized,
//                           ).paddingOnly(bottom: 16.h),
//                         ),
//
//                       /// New Password
//                       CommonInputFormField(
//                         textEditingController: newPassCtr,
//                         maxLines: 1,
//                         textInputType: TextInputType.text,
//                         obscureText: !resetPasswordWatch.isShowNewPassword,
//                         textInputAction: TextInputAction.next,
//                         maxLength: maxPasswordLength,
//                         suffixWidget: InkWell(
//                           onTap: () {
//                             resetPasswordWatch.updateIsShowNewPassword();
//                           },
//                           child: CommonImage(
//                             strIcon: !resetPasswordWatch.isShowNewPassword
//                                 ? Assets.svgs.svgPasswordEye.path
//                                 : Assets.svgs.svgHidePaswordEye.path,
//                             boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                             height: context.isTablet ? 24.h : 20.h,
//                             width: context.isTablet ? 24.h : 20.h,
//                           ),
//                         ).paddingOnly(right: 10.w),
//                         validator: (v) {
//                           if (validatePassword(value: v, forPass: true, forCurrentPass: false, changePassword: true) !=
//                               null) {
//                             return validatePassword(
//                                 value: v, forPass: true, forCurrentPass: false, changePassword: true);
//                           }
//                           if (newPassCtr.text.isNotEmpty && confirmPassCtr.text.length > 7) {
//                             if (confirmPassCtr.text != newPassCtr.text) {
//                               return LocaleKeys.keyNewAndConfirmPasswordNotMatchValidation.localized;
//                             }
//                           }
//                           if (newPassCtr.text.isNotEmpty &&
//                               currentPassCtr.text.isNotEmpty &&
//                               newPassCtr.text.length > 7 &&
//                               currentPassCtr.text.length > 7) {
//                             if (newPassCtr.text == currentPassCtr.text) {
//                               return LocaleKeys.keyCurrentPasswordAndNewPasswordMustBeDifferent.localized;
//                             }
//                           }
//                           return null;
//                         },
//                         hintText: LocaleKeys.keyNewPassword.localized,
//                       ).paddingOnly(bottom: 16.h),
//
//                       /// Confirm Password
//                       CommonInputFormField(
//                         textEditingController: confirmPassCtr,
//                         maxLines: 1,
//                         textInputType: TextInputType.text,
//                         obscureText: !resetPasswordWatch.isShowConfirmPassword,
//                         textInputAction: TextInputAction.next,
//                         maxLength: maxPasswordLength,
//                         suffixWidget: InkWell(
//                           onTap: () {
//                             resetPasswordWatch.updateIsShowConfirmPassword();
//                           },
//                           child: CommonImage(
//                             strIcon: !resetPasswordWatch.isShowConfirmPassword
//                                 ? Assets.svgs.svgPasswordEye.path
//                                 : Assets.svgs.svgHidePaswordEye.path,
//                             boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                             height: context.isTablet ? 24.h : 20.h,
//                             width: context.isTablet ? 24.h : 20.h,
//                           ),
//                         ).paddingOnly(right: 10.w),
//                         validator: (v) => validatePassword(value: v, forPass: true),
//                         hintText: LocaleKeys.keyConfirmPassword.localized,
//                       ).paddingOnly(bottom: 25.h),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Animated Validation Rules
//               SlideTransition(
//                 position: _slideValidationAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: ValueListenableBuilder<Map<String, bool>>(
//                     valueListenable: validationState,
//                     builder: (context, value, child) {
//                       return Column(
//                         children: [
//                           commonRowForValidation(
//                             value['minLength'] ?? false,
//                             LocaleKeys.keyMinimum8Character.localized,
//                           ),
//                           commonRowForValidation(
//                             value['number'] ?? false,
//                             LocaleKeys.keyAtLeastOneNumber.localized,
//                           ),
//                           commonRowForValidation(
//                             value['symbol'] ?? false,
//                             LocaleKeys.keyAtLeastOneSymbol.localized,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ).paddingOnly(left: 30.w, right: 30.w),
//         ),
//       ),
//     );
//   }
//
//   /// CommonRow For Validation
//   Padding commonRowForValidation(bool isChecked, String title) {
//     return Row(
//       children: [
//         CommonImage(
//           strIcon: isChecked ? Assets.svgs.svgCheckGreen.path : Assets.svgs.svgEmptyCheck.path,
//           height: 15.h,
//           width: 15.h,
//           boxFit: BoxFit.fitWidth,
//         ).paddingOnly(right: 10.w),
//         CommonText(
//           title: title,
//           textStyle: TextStyles.regular.copyWith(color: AppColors.fontSecondaryColor, fontSize: 13.sp),
//         )
//       ],
//     ).paddingOnly(bottom: 12.h);
//   }
//
//   /// Reset Password Api Call
//   Future<void> resetPasswordApiCall() async {
//     final resetPasswordWatch = ref.watch(resetPasswordController);
//     await resetPasswordWatch.resetPasswordApi(
//       context,
//       password: newPassCtr.text,
//       email: widget.email,
//       confirmPassword: confirmPassCtr.text,
//       otp: widget.otp,
//     );
//     if (resetPasswordWatch.resetPasswordState.success?.status == ApiEndPoints.apiStatus_200) {
//       showSuccessBottomSheet(
//           context: context,
//           title: LocaleKeys.keyPasswordChanged.localized,
//           subTitle: LocaleKeys.keyPasswordChangedNote.localized,
//           onTap: () {
//             /// Login Screen Navigation
//             ref.read(navigationStackController).pushAndRemoveAll(NavigationStackItem.signIn());
//           },
//           isButtonRequired: true,
//           buttonText:
//               widget.isForChangePassword ? LocaleKeys.keyGoToHome.localized : LocaleKeys.keyGoToLogin.localized);
//     }
//   }
//
//   /// Change Password Api Call
//   Future<void> changePasswordApiCall() async {
//     final resetPasswordWatch = ref.watch(resetPasswordController);
//     // await resetPasswordWatch.changePasswordApi(
//     //   context,
//     //   oldPassword: currentPassCtr.text,
//     //   password: newPassCtr.text,
//     //   confirmPassword: confirmPassCtr.text,
//     // );
//     // if (resetPasswordWatch.changePasswordState.success?.status == ApiEndPoints.apiStatus_200) {
//     //   showSuccessBottomSheet(
//     //       context: context,
//     //       title: LocaleKeys.keyPasswordChanged.localized,
//     //       subTitle: LocaleKeys.keyPasswordChangedNote.localized,
//     //       onTap: () {
//     //         /// Profile Screen Navigation
//     //         ref.read(navigationStackController).pop();
//     //         ref.read(navigationStackController).pop();
//     //       },
//     //       isButtonRequired: true,
//     //       buttonText:
//     //           widget.isForChangePassword ? LocaleKeys.keyGoToHome.localized : LocaleKeys.keyGoToLogin.localized);
//     // }
//   }
// }
