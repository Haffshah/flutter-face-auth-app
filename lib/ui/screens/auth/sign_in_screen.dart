// import 'package:face_match/framework/controller/auth/sign_in_controller.dart';
// // import 'package:face_match/framework/controller/profile/profile_controller.dart';
// import 'package:face_match/framework/provider/network/api_end_points.dart';
// import 'package:face_match/framework/utils/extension/extension.dart';
// import 'package:face_match/framework/utils/extension/string_extension.dart';
// import 'package:face_match/framework/utils/local_storage/session.dart';
// import 'package:face_match/ui/routing/navigation_stack_item.dart';
// import 'package:face_match/ui/routing/stack.dart';
// import 'package:face_match/ui/utils/const/app_constants.dart';
// import 'package:face_match/ui/utils/const/app_enums.dart';
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
// import 'package:face_match/ui/utils/widgets/dialog_progressbar.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// // lib/ui/screens/auth/sign_in_screen.dart
//
// class SignInScreen extends ConsumerStatefulWidget {
//   const SignInScreen({super.key});
//
//   @override
//   ConsumerState<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends ConsumerState<SignInScreen>
//     with BaseConsumerStatefulWidget, SingleTickerProviderStateMixin {
//   // Add animation controllers and animations
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<Offset> _slideFormAnimation;
//
//   ///
//   /// FormKey
//   final formKey = GlobalKey<FormState>();
//
//   /// TextEditingController
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(signInController).disposeController(isNotify: true);
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
//     _slideAnimation = Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );
//
//     _slideFormAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget buildPage(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: const Offstage() /* _bodyWidget()*/,
//         bottomNavigationBar: _buildTermsAndPrivacy(),
//       ),
//     );
//   }
//
//   // Widget _bodyWidget() {
//   //   final accountWatch = ref.watch(profileController);
//   //
//   //   return Stack(
//   //     children: [
//   //       /// Background
//   //       Column(
//   //         children: [
//   //           _buildIllustration(),
//   //           const Spacer(),
//   //         ],
//   //       ),
//   //
//   //       SingleChildScrollView(
//   //         child: Form(
//   //           key: formKey,
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               CommonAppBar(title: ''),
//   //               SizedBox(height: 190.h),
//   //               CommonText(
//   //                 title: LocaleKeys.keySignIn.localized,
//   //                 textStyle: TextStyles.semiBold.copyWith(
//   //                   fontSize: 26.sp,
//   //                   color: AppColors.fontPrimaryColor,
//   //                 ),
//   //               ).alignAtCenter(),
//   //               SizedBox(height: 24.h),
//   //               _buildForm(),
//   //               SizedBox(height: 16.h),
//   //               _buildForgotPassword(),
//   //               SizedBox(height: 24.h),
//   //               _buildSignInButton(),
//   //               SizedBox(height: 16.h),
//   //               _buildSignUpButton(),
//   //               SizedBox(height: 24.h),
//   //             ],
//   //           ).paddingSymmetric(horizontal: 20.w),
//   //         ),
//   //       ),
//   //
//   //       DialogProgressBar(isLoading: accountWatch.deleteAccountApiState.isLoading)
//   //     ],
//   //   );
//   // }
//
//   Widget _buildIllustration() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: Center(
//           child: CommonImage(
//             strIcon: Assets.svgs.svgLoginBg.path,
//             height: 200.h,
//             width: double.maxFinite,
//             boxFit: BoxFit.fill,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForm() {
//     final signInWatch = ref.watch(signInController);
//
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideFormAnimation,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CommonInputFormField(
//               textEditingController: emailController,
//               hintText: LocaleKeys.keyEmail.localized,
//               textInputType: TextInputType.emailAddress,
//               textInputAction: TextInputAction.next,
//               validator: (val) {
//                 return validateEmail(val);
//               },
//             ),
//             SizedBox(height: 16.h),
//             CommonInputFormField(
//               textEditingController: passwordController,
//               hintText: LocaleKeys.keyPassword.localized,
//               obscureText: !signInWatch.isPasswordVisible,
//               textInputAction: TextInputAction.done,
//               maxLength: maxPasswordLength,
//               validator: (val) {
//                 return validatePassword(value: val, forPass: true);
//               },
//               suffixWidget: IconButton(
//                 icon: Icon(
//                   signInWatch.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                   color: AppColors.grey,
//                 ),
//                 onPressed: signInWatch.togglePasswordVisibility,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForgotPassword() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: InkWell(
//         onTap: () => ref
//             .read(navigationStackController)
//             .push(const NavigationStackItem.forgotPassword(fromScreen: FromScreen.signIn)),
//         child: CommonText(
//           title: '${LocaleKeys.keyForgotPassword.localized}?',
//           textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: AppColors.blue),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignInButton() {
//     final signInWatch = ref.watch(signInController);
//     // final accountWatch = ref.watch(profileController);
//
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideFormAnimation,
//         child: CommonButton(
//           isButtonEnabled: true,
//           isShowLoader: true,
//           onTap: () {
//             final result = formKey.currentState?.validate();
//             if (result != null && result == true) {
//               signInApiCall();
//             }
//           },
//           buttonText: LocaleKeys.keySignIn.localized,
//           isLoading:
//               signInWatch.isLoading ||
//               signInWatch.signInApiState.isLoading /*||
//               accountWatch.deleteAccountApiState.isLoading*/,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpButton() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideFormAnimation,
//         child: CommonButton(
//           isButtonEnabled: true,
//           onTap: () {
//             ref.read(navigationStackController).push(const NavigationStackItem.signUp());
//           },
//           buttonText: LocaleKeys.keySignUp.localized,
//           buttonEnabledColor: AppColors.secondary,
//           buttonTextColor: AppColors.black,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTermsAndPrivacy() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Center(
//           child: Text.rich(
//             TextSpan(
//               text: '${LocaleKeys.keyBySigningInToContinueface_match.localized}\n',
//               style: TextStyles.regular.copyWith(fontSize: 12.sp, color: AppColors.grey),
//               children: [
//                 TextSpan(
//                   text: LocaleKeys.keyTermsAndConditions.localized,
//                   style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 13.sp),
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () {
//                       ref.read(navigationStackController).push(NavigationStackItem.cms(cmsUrl: ''));
//                     },
//                 ),
//                 TextSpan(text: ' ${LocaleKeys.keyAnd.localized} '),
//                 TextSpan(
//                   text: LocaleKeys.keyPrivacyPolicy.localized,
//                   style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 13.sp),
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () {
//                       ref.read(navigationStackController).push(NavigationStackItem.cms(cmsUrl: ''));
//                     },
//                 ),
//               ],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     ).paddingOnly(bottom: 30.h);
//   }
//
//   /// SignIn Api Call
//   Future<void> signInApiCall() async {
//     final signInWatch = ref.watch(signInController);
//     await signInWatch.signInApi(context, email: emailController.text, password: passwordController.text);
//     if (signInWatch.signInApiState.success?.status == ApiEndPoints.apiStatus_200) {
//       SessionHelper.userAccessToken = signInWatch.signInApiState.success?.data?.token ?? '';
//       SessionHelper.getUserId = signInWatch.signInApiState.success?.data?.id.toString() ?? '';
//       SessionHelper.getUserMobileNo = signInWatch.signInApiState.success?.data?.phoneNumber ?? '';
//       SessionHelper.getUserEmail = signInWatch.signInApiState.success?.data?.email ?? '';
//       SessionHelper.getUserState = signInWatch.signInApiState.success?.data?.state ?? '';
//       SessionHelper.getUserCity = signInWatch.signInApiState.success?.data?.city ?? '';
//       SessionHelper.getUserAddress = signInWatch.signInApiState.success?.data?.address ?? '';
//       SessionHelper.getUserLatLng =
//           signInWatch.signInApiState.success?.data?.latitude != null &&
//               signInWatch.signInApiState.success?.data?.longitude != null
//           ? "${signInWatch.signInApiState.success?.data?.latitude ?? ''}, ${signInWatch.signInApiState.success?.data?.longitude ?? ''}"
//           : '';
//       SessionHelper.getUserName =
//           signInWatch.signInApiState.success?.data?.companyName ??
//           signInWatch.signInApiState.success?.data?.fullName ??
//           '';
//       SessionHelper.getCompanyType = signInWatch.signInApiState.success?.data?.companyType ?? '';
//       SessionHelper.currentUserMember = signInWatch.signInApiState.success?.data?.isMember ?? 0;
//       if (signInWatch.signInApiState.success?.data?.avatar != null) {
//         SessionHelper.getUserProfilePic = signInWatch.signInApiState.success?.data?.avatar?.fullPath ?? '';
//       }
//       if (signInWatch.signInApiState.success?.data?.deleteAccountRequestAt != null &&
//           signInWatch.signInApiState.success?.data?.deleteAccountRequestAt != '') {
//         /// Account Delete Request
//         accountDeletionRequestFlow();
//       } else {
//         /// Simple Login
//         simpleLogin();
//       }
//     }
//   }
//
//   /// Account Delete IS Already Request Flow
//   void accountDeletionRequestFlow() {
//     final accountWatch = ref.read(profileController);
//     showConfirmationBottomSheet(
//       context: context,
//       title: LocaleKeys.keyRemoveDeleteAccountRequest.localized,
//       subTitle: LocaleKeys.keyRemoveDeleteAccountRequestNote.localized,
//       btn1Name: LocaleKeys.keyNo.localized,
//       btn2Name: LocaleKeys.keyYes.localized,
//       didTakeAction: (isPositive) async {
//         if (isPositive) {
//           await accountWatch.deleteAccountApi(context, isDelete: false).then((value) {
//             if (value.success?.status == ApiEndPoints.apiStatus_200) {
//               simpleLogin();
//             }
//           });
//         } else {
//           SessionHelper.sessionLogout(ref);
//         }
//       },
//     );
//   }
//
//   /// Simple Login
//   Future<void> simpleLogin() async {
//     /// Dashboard Screen Navigation
//     ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashboard());
//   }
// }
