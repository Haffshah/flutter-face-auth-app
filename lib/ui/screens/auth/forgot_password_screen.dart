// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:face_match/framework/controller/auth/forgot_password_controller.dart';
// import 'package:face_match/framework/provider/network/api_end_points.dart';
// import 'package:face_match/framework/utils/extension/context_extension.dart';
// import 'package:face_match/framework/utils/extension/extension.dart';
// import 'package:face_match/framework/utils/extension/string_extension.dart';
// import 'package:face_match/ui/routing/navigation_stack_item.dart';
// import 'package:face_match/ui/routing/stack.dart';
// import 'package:face_match/ui/utils/const/app_enums.dart';
// import 'package:face_match/ui/utils/const/form_validations.dart';
// import 'package:face_match/ui/utils/helper/base_widget.dart';
// import 'package:face_match/ui/utils/theme/app_colors.dart';
// import 'package:face_match/ui/utils/theme/app_strings.g.dart';
// import 'package:face_match/ui/utils/theme/assets.gen.dart';
// import 'package:face_match/ui/utils/theme/text_style.dart';
// import 'package:face_match/ui/utils/widgets/common_appbar.dart';
// import 'package:face_match/ui/utils/widgets/common_button.dart';
// import 'package:face_match/ui/utils/widgets/common_form_field.dart';
// import 'package:face_match/ui/utils/widgets/common_image.dart';
// import 'package:face_match/ui/utils/widgets/common_text.dart';
//
// class ForgotPasswordScreen extends ConsumerStatefulWidget {
//   const ForgotPasswordScreen({super.key, required this.fromScreen});
//
//   final FromScreen fromScreen;
//
//   @override
//   ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
//     with BaseConsumerStatefulWidget, SingleTickerProviderStateMixin {
//   /// Form Key
//   final formKey = GlobalKey<FormState>();
//
//   /// Text Editing controller
//   TextEditingController emailCtr = TextEditingController();
//
//   ///Init Override
//
//   // Add animation controllers and animations
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideIconAnimation;
//   late Animation<Offset> _slideTextAnimation;
//   late Animation<Offset> _slideFormAnimation;
//   late Animation<Offset> _slideButtonAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       final forgotPasswordWatch = ref.watch(forgotPasswordController);
//       forgotPasswordWatch.disposeController(isNotify: true);
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
//     _slideTextAnimation = Tween<Offset>(
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
//     _slideButtonAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 1.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
//     ));
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     emailCtr.dispose();
//     super.dispose();
//   }
//
//   ///Build Override
//   @override
//   Widget buildPage(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(),
//       body: _bodyWidget(),
//     );
//   }
//
//   ///Body Widget
//   Widget _bodyWidget() {
//     final forgotPasswordWatch = ref.watch(forgotPasswordController);
//
//     return SizedBox(
//       height: context.height,
//       width: context.width,
//       child: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 60.h),
//
//               // Animated Icon
//               SlideTransition(
//                 position: _slideIconAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: CommonImage(
//                       strIcon: Assets.svgs.svgForgotPassword.path,
//                       height: 70.h,
//                       width: 70.h,
//                     ),
//                   ).paddingOnly(bottom: 15.h),
//                 ),
//               ),
//
//               // Animated Text
//               SlideTransition(
//                 position: _slideTextAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         title: widget.fromScreen == FromScreen.profile
//                             ? LocaleKeys.keyPasswordReset.localized
//                             : LocaleKeys.keyForgotYourPassword.localized,
//                         textStyle: TextStyles.semiBold.copyWith(
//                           fontSize: 26.sp,
//                           color: AppColors.fontPrimaryColor,
//                         ),
//                       ).paddingOnly(bottom: 10.h),
//                       CommonText(
//                         title: LocaleKeys.keyForgotYourPasswordNote.localized,
//                         maxLines: 5,
//                         textStyle: TextStyles.light.copyWith(
//                           fontSize: 14.sp,
//                           color: AppColors.fontSecondaryColor,
//                         ),
//                       ).paddingOnly(bottom: 35.h),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Animated Form
//               SlideTransition(
//                 position: _slideFormAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: CommonInputFormField(
//                     textEditingController: emailCtr,
//                     maxLines: 1,
//                     textInputType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                     validator: (v) => validateEmail(v),
//                     hintText: LocaleKeys.keyEmail.localized,
//                   ).paddingOnly(bottom: 25.h),
//                 ),
//               ),
//
//               // Animated Buttons
//               SlideTransition(
//                 position: _slideButtonAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     children: [
//                       CommonButton(
//                         buttonText: LocaleKeys.keyResetMyPassword.localized,
//                         isButtonEnabled: true,
//                         isLoading: forgotPasswordWatch.forgotState.isLoading,
//                         onTap: () async {
//                           final result = formKey.currentState?.validate();
//                           if (result != null && result == true) {
//                             await forgotPasswordApi();
//                           }
//                         },
//                       ),
//                       if (widget.fromScreen != FromScreen.profile)
//                         InkWell(
//                           onTap: () => ref.read(navigationStackController).pop(),
//                           child: CommonText(
//                             title: LocaleKeys.keyBackToSignIn.localized,
//                             textStyle: TextStyles.regular.copyWith(
//                               fontSize: 14.sp,
//                               color: AppColors.fontSecondaryColor,
//                             ),
//                           ),
//                         ).paddingOnly(top: 20.h).alignAtCenter(),
//                     ],
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
//   /// Forgot Password Api Call
//   Future<void> forgotPasswordApi() async {
//     final forgotPasswordWatch = ref.watch(forgotPasswordController);
//     await forgotPasswordWatch.forgotPasswordApi(context, email: emailCtr.text);
//     if (forgotPasswordWatch.forgotState.success?.status == ApiEndPoints.apiStatus_200) {
//       // /// Otp Verification Screen Navigation
//       // ref.read(navigationStackController).push(
//       //       NavigationStackItem.otpVerification(
//       //         fromScreen: widget.fromScreen,
//       //         otpSentOn: emailCtr.text,
//       //       ),
//       // );
//     }
//   }
// }
