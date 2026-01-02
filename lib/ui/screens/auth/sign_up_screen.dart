// import 'dart:async';
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:face_match/framework/controller/auth/otp_verification_controller.dart';
// import 'package:face_match/framework/controller/auth/sign_up_controller.dart';
// import 'package:face_match/framework/provider/network/api_end_points.dart';
// import 'package:face_match/ui/routing/navigation_stack_item.dart';
// import 'package:face_match/ui/routing/stack.dart';
// import 'package:face_match/ui/screens/auth/helper/animation_duration.dart';
// import 'package:face_match/ui/utils/const/app_constants.dart';
// import 'package:face_match/ui/utils/const/app_enums.dart';
// import 'package:face_match/ui/utils/const/form_validations.dart';
// import 'package:face_match/ui/utils/helper/base_widget.dart';
// import 'package:face_match/ui/utils/helper/image_picker_manager.dart';
// import 'package:face_match/ui/utils/helper/location_helper/google_place_helper.dart';
// import 'package:face_match/ui/utils/theme/app_strings.g.dart';
// import 'package:face_match/ui/utils/theme/assets.gen.dart';
// import 'package:face_match/ui/utils/theme/theme.dart';
// import 'package:face_match/ui/utils/widgets/common_appbar.dart';
// import 'package:face_match/ui/utils/widgets/common_button.dart';
// import 'package:face_match/ui/utils/widgets/common_check_box.dart';
// import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
// import 'package:face_match/ui/utils/widgets/common_form_field.dart';
// import 'package:face_match/ui/utils/widgets/common_image.dart';
// import 'package:face_match/ui/utils/widgets/common_text.dart';
// import 'package:face_match/ui/utils/widgets/dialog_progressbar.dart';
//
// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends ConsumerState<SignUpScreen>
//     with BaseConsumerStatefulWidget, SingleTickerProviderStateMixin {
//   ///  Animation controller and animations
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   // late Animation<Offset> _slideIconAnimation;
//   late Animation<Offset> _slideTitleAnimation;
//   late Animation<Offset> _slideFormAnimation;
//   late Animation<Offset> _slideButtonAnimation;
//   late Animation<double> _stepTransitionAnimation;
//
//   List<Map<String, dynamic>> _addressSuggestions = [];
//   bool _isSearchingAddress = false;
//
//   /// Form Key
//   final formKey = GlobalKey<FormState>();
//   final _emailForm = GlobalKey<FormState>();
//   final _phoneForm = GlobalKey<FormState>();
//
//   /// Text Editing controller
//   TextEditingController companyFirmNameCtr = TextEditingController();
//   TextEditingController emailCtr = TextEditingController();
//   TextEditingController phoneNumberCtr = TextEditingController();
//   TextEditingController passwordCtr = TextEditingController();
//   TextEditingController confirmPasswordCtr = TextEditingController();
//   TextEditingController addressNameCtr = TextEditingController();
//   TextEditingController latLangCtr = TextEditingController();
//   TextEditingController stateCtr = TextEditingController();
//   TextEditingController cityCtr = TextEditingController();
//
//   ///Init Override
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
//       final signUpWatch = ref.watch(signUpController);
//       signUpWatch.disposeController(isNotify: true);
//
//       /// State List Api Call
//       // await stateListApiCall();
//     });
//   }
//
//   void _setupAnimations() {
//     // Main animation controller for step transitions
//     _animationController = AnimationController(
//       duration: AnimationDurations.stepTransition,
//       vsync: this,
//     );
//
//     // Smooth fade animation for all content
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: AnimationCurves.contentFade,
//     ));
//
//     // Step transition with custom timing
//     _stepTransitionAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: AnimationCurves.stepTransition,
//     ));
//
//     // Optimized slide animations with smoother curves
//     // _slideIconAnimation = Tween<Offset>(
//     //   begin: const Offset(-0.3, 0.0),
//     //   end: Offset.zero,
//     // ).animate(CurvedAnimation(
//     //   parent: _animationController,
//     //   curve: const Interval(0.0, 0.6, curve: AnimationCurves.slideIn),
//     // ));
//
//     _slideTitleAnimation = Tween<Offset>(
//       begin: const Offset(0.3, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.2, 0.7, curve: AnimationCurves.slideIn),
//     ));
//
//     _slideFormAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.3, 0.8, curve: AnimationCurves.slideIn),
//     ));
//
//     _slideButtonAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.4, 1.0, curve: AnimationCurves.slideIn),
//     ));
//
//     // Start initial animations
//     _animationController.forward();
//   }
//
//   /// Handles smooth transition between steps
//   /// [currentStep] - The step to transition to
//   void _handleStepTransition(int currentStep) {
//     // First reverse current animations
//     _animationController.reverse().then((_) {
//       // Update step in state
//       final signUpWatch = ref.read(signUpController);
//       signUpWatch.updateCurrentStep(currentStep);
//
//       // Add small delay for smoother transition
//       Future.delayed(const Duration(milliseconds: 50), () {
//         // Forward new step animations
//         _animationController.forward();
//       });
//     });
//   }
//
//   ///Dispose Override
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   ///Build Override
//   @override
//   Widget buildPage(BuildContext context) {
//     final signUpWatch = ref.watch(signUpController);
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: CommonAppBar(
//           backgroundColor: AppColors.transparent,
//           title: LocaleKeys.keySignUp.localized,
//           centerTitle: true,
//           onLeadingPress: () {
//             if (signUpWatch.currentStep == 2) {
//               _handleStepTransition(1);
//               return;
//             }
//             ref.read(navigationStackController).pop();
//           },
//           actions: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CommonText(
//                     title: signUpWatch.currentStep.toString(),
//                     textStyle: TextStyles.semiBold.copyWith(
//                       fontSize: 14.sp,
//                       color: AppColors.black,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4.w),
//                     child: CommonText(
//                       title: LocaleKeys.keyOf.localized,
//                       textStyle: TextStyles.semiBold.copyWith(
//                         fontSize: 14.sp,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   ),
//                   CommonText(
//                     title: '2',
//                     textStyle: TextStyles.semiBold.copyWith(
//                       fontSize: 14.sp,
//                       color: AppColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: _bodyWidget(),
//         bottomNavigationBar: _bottomNavigationBarWidget(),
//       ),
//     );
//   }
//
//   ///Body Widget
//   Widget _bodyWidget() {
//     final signUpWatch = ref.watch(signUpController);
//
//     return AnimatedBuilder(
//       animation: _stepTransitionAnimation,
//       builder: (context, child) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               Divider(color: AppColors.clrF1F1F1, thickness: 2).paddingOnly(bottom: 24.h),
//               signUpWatch.currentStep == 1
//                   ? FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: signUpStepOne(),
//                     )
//                   : FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: signUpStepTwo(),
//                     ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// Sign Up Step One Widget
//   Widget signUpStepOne() {
//     final signUpWatch = ref.watch(signUpController);
//
//     return Column(
//       children: [
//         // Animated Title
//         SlideTransition(
//           position: _slideTitleAnimation,
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: CommonText(
//               title: LocaleKeys.keyWhatsYourBusinessType.localized,
//               textStyle: TextStyles.medium.copyWith(
//                 fontSize: 16.sp,
//                 color: AppColors.black,
//               ),
//             ).paddingOnly(bottom: 14.h),
//           ),
//         ),
//
//         // Animated Service Card
//         SlideTransition(
//           position: _slideFormAnimation,
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: _buildCommonCard(
//               signUpWatch,
//               AppColors.clrFFE98E,
//               businessTypeService,
//               LocaleKeys.keyServiceNote.localized,
//               Assets.images.icServiceWomen.path,
//             ).paddingOnly(bottom: 16.h),
//           ),
//         ),
//
//         // Animated Delivery Card
//         SlideTransition(
//           position: _slideFormAnimation,
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: _buildCommonCard(
//               signUpWatch,
//               AppColors.clrC2F3EC,
//               businessTypeDelivery,
//               LocaleKeys.keyDeliveryNote.localized,
//               Assets.images.icBusinessPerson.path,
//             ).paddingOnly(bottom: 16.h),
//           ),
//         ),
//       ],
//     ).paddingSymmetric(horizontal: 20.w);
//   }
//
//   /// Terms and Privacy Widget
//   Widget _buildTermsAndPrivacy(SignUpController signUpWatch) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Terms and Conditions CheckBox
//         CommonCheckBox(
//           value: signUpWatch.isTermsAccepted,
//           onChanged: (val) {
//             signUpWatch.updateIsTermsAccepted(val ?? false);
//           },
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4.r),
//           ),
//           activeColor: AppColors.primary,
//           checkColor: AppColors.primary,
//           fillColor: AppColors.white,
//           selectedBorder: AppColors.primary,
//           unSelectedBorder: AppColors.greyMedium,
//         ),
//
//         /// Terms and Conditions Text
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text.rich(
//               TextSpan(
//                 text: '${LocaleKeys.keyBySigningInToContinueface_match.localized}\n',
//                 style: TextStyles.regular.copyWith(
//                   fontSize: 12.sp,
//                   color: AppColors.grey,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: LocaleKeys.keyTermsAndConditions.localized,
//                     style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 13.sp),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         // Handle terms tap
//                       },
//                   ),
//                   TextSpan(text: ' ${LocaleKeys.keyAnd.localized} '),
//                   TextSpan(
//                     text: LocaleKeys.keyPrivacyPolicy.localized,
//                     style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 13.sp),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         // Handle privacy tap
//                       },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     ).paddingOnly(left: 20.w, right: 20.h, bottom: 10.h);
//   }
//
//   /// Common Card Widget
//   Widget _buildCommonCard(SignUpController signUpWatch, Color color, String title, String subTitle, String imagePath) {
//     return InkWell(
//       onTap: () {
//         signUpWatch.updateBusinessType(title);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.sp),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(24.r),
//           border: Border.all(
//             color: signUpWatch.businessType == title ? AppColors.primary : AppColors.transparent,
//             width: 2.w,
//           ),
//         ),
//         child: Row(
//           children: [
//             CommonImage(
//               strIcon: imagePath,
//               height: 160.h,
//               boxFit: BoxFit.contain,
//             ).paddingOnly(right: 10.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CommonText(
//                     title: title.toUpperCase(),
//                     textStyle: TextStyles.bold.copyWith(
//                       fontSize: 18.sp,
//                       color: AppColors.darkNavyBlue,
//                     ),
//                   ),
//                   CommonText(
//                     title: subTitle,
//                     maxLines: 10,
//                     textStyle: TextStyles.regular.copyWith(
//                       fontSize: 13.sp,
//                       color: AppColors.darkNavyBlue,
//                     ),
//                   ).paddingOnly(top: 5.h),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Sign Up Step Two Widget
//   Form signUpStepTwo() {
//     final verifyOtpWatch = ref.watch(otpVerificationController);
//     final signUpWatch = ref.watch(signUpController);
//
//     return Form(
//       key: formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SlideTransition(
//             position: _slideTitleAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: CommonText(
//                 title: LocaleKeys.keyLetsSetUpYourFirm.localized,
//                 textStyle: TextStyles.medium.copyWith(
//                   fontSize: 16.sp,
//                   color: AppColors.black,
//                 ),
//               ).paddingOnly(bottom: 14.h),
//             ),
//           ),
//
//           /// Image
//           SlideTransition(
//             position: _slideFormAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   profileImageView().alignAtCenter().paddingOnly(bottom: 16.h),
//
//                   /// First Name & Last Name
//                   CommonInputFormField(
//                     textEditingController: companyFirmNameCtr,
//                     maxLines: 1,
//                     textInputType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     validator: (v) =>
//                         validateText(v, LocaleKeys.keyCompanyNameRequiredValidation.localized, minLength: 3),
//                     hintText: LocaleKeys.keyCompanyFirmName.localized,
//                   ).paddingOnly(bottom: 16.h),
//
//                   /// Phone Number
//                   Form(
//                     key: _phoneForm,
//                     child: CommonInputFormField(
//                       textEditingController: phoneNumberCtr,
//                       maxLines: 1,
//                       maxLength: maxMobileLength,
//                       prefixWidget: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CommonText(
//                                 title: phoneCode,
//                                 textStyle: TextStyles.medium.copyWith(color: AppColors.fontBlack, fontSize: 13.sp),
//                               ).paddingOnly(left: 12.w),
//                               Container(
//                                 width: 1.w,
//                                 height: 50,
//                                 color: AppColors.greyMedium,
//                               ).paddingOnly(left: 15.w, right: 10.w)
//                             ],
//                           ),
//                         ],
//                       ),
//                       suffixWidget: signUpWatch.isPhoneVerified
//                           ? Icon(Icons.verified, color: AppColors.green)
//                           : CommonButton(
//                               height: 30.h,
//                               width: 70.w,
//                               buttonTextSize: 12.sp,
//                               isButtonEnabled: true,
//                               isLoading: verifyOtpWatch.verifyPhoneApiState.isLoading,
//                               onTap: () async {
//                                 final result = _phoneForm.currentState?.validate();
//                                 if (result != null && result == true) {
//                                   await verifyPhoneApiCall();
//                                 }
//                               },
//                               buttonEnabledColor: AppColors.primary,
//                               buttonText: LocaleKeys.keyVerify.localized,
//                             ).paddingOnly(left: 10.w, top: 8.h, bottom: 8.h, right: 8.w),
//                       textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
//                       textInputType: TextInputType.phone,
//                       textInputAction: TextInputAction.next,
//                       validator: (v) => validateMobile(v),
//                       hintText: LocaleKeys.keyPhoneNumber.localized,
//                     ).paddingOnly(bottom: 16.h),
//                   ),
//
//                   /// Email
//                   Form(
//                     key: _emailForm,
//                     child: CommonInputFormField(
//                       textEditingController: emailCtr,
//                       maxLines: 1,
//                       suffixWidget: signUpWatch.isEmailVerified
//                           ? Icon(Icons.verified, color: AppColors.green)
//                           : CommonButton(
//                               height: 30.h,
//                               width: 70.w,
//                               buttonTextSize: 12.sp,
//                               isButtonEnabled: true,
//                               isLoading: verifyOtpWatch.verifyEmailApiState.isLoading,
//                               onTap: () async {
//                                 final result = _emailForm.currentState?.validate();
//                                 if (result != null && result == true) {
//                                   await verifyEmailApiCall();
//                                 }
//                               },
//                               buttonEnabledColor: AppColors.primary,
//                               buttonText: LocaleKeys.keyVerify.localized,
//                             ).paddingOnly(left: 10.w, top: 8.h, bottom: 8.h, right: 8.w),
//                       textInputType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.next,
//                       validator: (v) => validateEmail(v),
//                       hintText: LocaleKeys.keyEmail.localized,
//                     ).paddingOnly(bottom: 16.h),
//                   ),
//
//                   /// Password
//                   CommonInputFormField(
//                     textEditingController: passwordCtr,
//                     maxLines: 1,
//                     textInputType: TextInputType.text,
//                     obscureText: !signUpWatch.isPasswordVisible,
//                     textInputAction: TextInputAction.next,
//                     maxLength: maxPasswordLength,
//                     suffixWidget: InkWell(
//                       onTap: () {
//                         signUpWatch.updateIsPasswordVisible();
//                       },
//                       child: CommonImage(
//                         strIcon: !signUpWatch.isPasswordVisible
//                             ? Assets.svgs.svgPasswordEye.path
//                             : Assets.svgs.svgHidePaswordEye.path,
//                         boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                         height: context.isTablet ? 24.h : 20.h,
//                         width: context.isTablet ? 24.h : 20.h,
//                       ),
//                     ).paddingOnly(right: 10.w),
//                     validator: (v) => validatePassword(value: v, forPass: true),
//                     hintText: LocaleKeys.keyCreatePassword.localized,
//                   ).paddingOnly(bottom: 16.h),
//
//                   /// Confirm Password
//                   CommonInputFormField(
//                     textEditingController: confirmPasswordCtr,
//                     maxLines: 1,
//                     textInputType: TextInputType.text,
//                     obscureText: !signUpWatch.isConfirmPasswordVisible,
//                     textInputAction: TextInputAction.next,
//                     maxLength: maxPasswordLength,
//                     suffixWidget: InkWell(
//                       onTap: () {
//                         signUpWatch.updateIsConfirmPasswordVisible();
//                       },
//                       child: CommonImage(
//                         strIcon: !signUpWatch.isConfirmPasswordVisible
//                             ? Assets.svgs.svgPasswordEye.path
//                             : Assets.svgs.svgHidePaswordEye.path,
//                         boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                         height: context.isTablet ? 24.h : 20.h,
//                         width: context.isTablet ? 24.h : 20.h,
//                       ),
//                     ).paddingOnly(right: 10.w),
//                     validator: (v) {
//                       if (v == null || v.isEmpty) {
//                         return LocaleKeys.keyPasswordRequiredValidation.localized;
//                       }
//                       if (v != passwordCtr.text) {
//                         return LocaleKeys.keyNewAndConfirmPasswordNotMatchValidation.localized;
//                       }
//                       return validatePassword(value: v);
//                     },
//                     hintText: LocaleKeys.keyConfirmPassword.localized,
//                   ).paddingOnly(bottom: 16.h),
//
//                   /// Address
//                   // Address Field
//                   _buildAddressField().paddingOnly(bottom: 16.h),
//
//                   /// Latitude & Longitude
//                   CommonInputFormField(
//                     textEditingController: latLangCtr,
//                     maxLines: 1,
//                     isEnable: false,
//                     textInputType: TextInputType.text,
//                     textInputAction: TextInputAction.done,
//                     validator: (v) => validateText(v, LocaleKeys.keyAddressValidation.localized, minLength: 3),
//                     hintText: LocaleKeys.keyLatitudeLongitude.localized,
//                   ).paddingOnly(bottom: 16.h),
//
//                   /// State
//                   CommonInputFormField(
//                     textEditingController: stateCtr,
//                     maxLines: 1,
//                     isEnable: false,
//                     textInputType: TextInputType.text,
//                     textInputAction: TextInputAction.done,
//                     validator: (value) {
//                       if (value == null) {
//                         return LocaleKeys.keyPleaseSelectAnyState.localized;
//                       }
//                       return null;
//                     },
//                     hintText: LocaleKeys.keyState.localized,
//                   ).paddingOnly(bottom: 16.h),
//
//                   /// City
//                   CommonInputFormField(
//                     textEditingController: cityCtr,
//                     maxLines: 1,
//                     isEnable: false,
//                     textInputType: TextInputType.text,
//                     textInputAction: TextInputAction.done,
//                     validator: (value) {
//                       if (value == null) {
//                         return LocaleKeys.keyPleaseSelectAnyCity.localized;
//                       }
//                       return null;
//                     },
//                     hintText: LocaleKeys.keyCity.localized,
//                   ).paddingOnly(bottom: 16.h)
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ).paddingOnly(left: 30.w, right: 30.w),
//     );
//   }
//
//   Widget _buildAddressField() {
//     return Column(
//       children: [
//         CommonInputFormField(
//           textEditingController: addressNameCtr,
//           hintText: LocaleKeys.keyAddress.localized,
//           onChanged: (value) async {
//             if (debounceTimer?.isActive ?? false) {
//               debounceTimer!.cancel();
//             }
//             debounceTimer = Timer(debounceDuration, () async {
//               if (value.length > 3) {
//                 setState(() => _isSearchingAddress = true);
//                 _addressSuggestions = await GooglePlacesHelper.getAutocomplete(value);
//                 setState(() => _isSearchingAddress = false);
//               } else {
//                 setState(() => _addressSuggestions.clear());
//               }
//             });
//           },
//           validator: (v) => validateText(v, LocaleKeys.keyAddressValidation.localized, minLength: 3),
//         ),
//         if (_isSearchingAddress)
//           DialogProgressBar(isLoading: true, height: 220.h)
//         else if (_addressSuggestions.isNotEmpty)
//           Container(
//             height: 220.h,
//             margin: EdgeInsets.only(top: 10.h),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withAlpha(10),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: ListView.builder(
//               itemCount: _addressSuggestions.length,
//               itemBuilder: (context, index) {
//                 final suggestion = _addressSuggestions[index];
//                 return ListTile(
//                   title: Text(suggestion['description']),
//                   onTap: () async {
//                     final details = await GooglePlacesHelper.getPlaceDetails(suggestion['place_id']);
//                     if (details != null) {
//                       addressNameCtr.text = details['formatted_address'] ?? '';
//                       final lat = details['geometry']['location']['lat'];
//                       final lng = details['geometry']['location']['lng'];
//                       latLangCtr.text = '$lat, $lng';
//
//                       // Extract state and city
//                       String? state, city;
//                       for (var c in details['address_components']) {
//                         if ((c['types'] as List).contains('administrative_area_level_1')) {
//                           state = c['long_name'];
//                         }
//                         if ((c['types'] as List).contains('locality')) {
//                           city = c['long_name'];
//                         }
//                       }
//                       stateCtr.text = state ?? '';
//                       cityCtr.text = city ?? '';
//
//                       setState(() {
//                         _addressSuggestions.clear();
//                       });
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   /// Bottom Navigation Bar Widget
//   Widget _bottomNavigationBarWidget() {
//     final signUpWatch = ref.watch(signUpController);
//
//     return SlideTransition(
//       position: _slideButtonAnimation,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (signUpWatch.currentStep == 1) _buildTermsAndPrivacy(signUpWatch),
//           Divider(color: AppColors.secondary, thickness: 2).paddingOnly(bottom: 10.h),
//           CommonButton(
//             buttonText: (signUpWatch.currentStep == 1) ? LocaleKeys.keyNext.localized : LocaleKeys.keySubmit.localized,
//             isButtonEnabled: (signUpWatch.currentStep == 1) ? signUpWatch.isTermsAccepted : true,
//             isLoading: ref.watch(signUpController).signupState.isLoading,
//             onTap: () async {
//               if (signUpWatch.currentStep == 1) {
//                 _handleStepTransition(2);
//                 return;
//               }
//
//               final isFormValid = formKey.currentState?.validate() == true &&
//                   _emailForm.currentState?.validate() == true &&
//                   _phoneForm.currentState?.validate() == true;
//
//               if (!isFormValid) return;
//
//               if (!signUpWatch.isEmailVerified) {
//                 commonToaster(LocaleKeys.keyInvalidEmailValidationIsNotDone.localized);
//                 return;
//               }
//               if (!signUpWatch.isPhoneVerified) {
//                 commonToaster(LocaleKeys.keyInvalidPhoneValidationIsNotDone.localized);
//                 return;
//               }
//               if (signUpWatch.verifiedEmail != emailCtr.text) {
//                 commonToaster(LocaleKeys.keyVerifiedEmailAndCurrentProvidedEmailIsNotSame.localized);
//                 signUpWatch.updateIsEmailVerified(signUpWatch.verifiedEmail, false);
//                 return;
//               }
//               if (signUpWatch.verifiedPhone != phoneNumberCtr.text) {
//                 commonToaster(LocaleKeys.keyVerifiedPhoneNumberAndCurrentProvidedPhoneNumberIsNotSame.localized);
//                 signUpWatch.updateIsPhoneVerified(signUpWatch.verifiedPhone, false);
//                 return;
//               }
//               if (signUpWatch.profileImage == null) {
//                 commonToaster(LocaleKeys.keyCompanyFirmLogoIsRequired.localized);
//                 return;
//               }
//
//               /// Sign up Api Call
//               signUpApiCall();
//             },
//           ).paddingOnly(left: 20.w, right: 20.w, bottom: 20.h),
//         ],
//       ),
//     );
//   }
//
//   /// Profile Image View
//   Widget profileImageView() {
//     final signUpWatch = ref.watch(signUpController);
//
//     return InkWell(
//       onTap: () async {
//         ///
//         final file = await ImagePickerManager.instance.openPicker(context);
//
//         if (file != null) {
//           signUpWatch.updateProfileImage(file);
//         }
//       },
//       child: Stack(
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 5, right: 5),
//             height: 95.h,
//             width: 95.h,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(20.r),
//               border: Border.all(
//                 color: AppColors.greyMedium,
//               ),
//             ),
//             child: Center(
//               child: signUpWatch.profileImage == null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CommonImage(
//                           strIcon: Assets.svgs.svgAdd.path,
//                           height: 27.h,
//                           width: 27.h,
//                           boxFit: context.isTablet ? BoxFit.fitWidth : BoxFit.scaleDown,
//                         ),
//                         CommonText(
//                           title: LocaleKeys.keyUploadLogo.localized,
//                           textStyle: TextStyles.regular.copyWith(
//                             fontSize: 8.sp,
//                             color: AppColors.grey,
//                           ),
//                         ),
//                       ],
//                     )
//                   : CommonImage(
//                       strIcon: signUpWatch.profileImage?.path ?? '',
//                       boxFit: BoxFit.cover,
//                       topLeftRadius: 20.r,
//                       topRightRadius: 20.r,
//                       bottomLeftRadius: 20.r,
//                       bottomRightRadius: 20.r,
//                       isFileImage: true,
//                       height: 95.h,
//                       width: 95.h,
//                     ),
//             ),
//           ),
//           if (signUpWatch.profileImage?.path != null)
//             Positioned(
//               top: 0,
//               right: 0,
//               child: InkWell(
//                 onTap: () {
//                   signUpWatch.updateProfileImage(null);
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         offset: Offset(0, 0),
//                         spreadRadius: 0.2,
//                         blurRadius: 2,
//                         color: AppColors.primary,
//                       ),
//                     ],
//                   ),
//                   child: Icon(Icons.close, color: AppColors.primary, size: 20.sp),
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
//
//   /// Sign Up Api Call
//   Future<void> signUpApiCall() async {
//     final signUpWatch = ref.watch(signUpController);
//     await signUpWatch.signUpApi(
//       context,
//       companyName: companyFirmNameCtr.text,
//       email: emailCtr.text,
//       password: passwordCtr.text,
//       phoneNo: phoneNumberCtr.text,
//       address: addressNameCtr.text,
//       state: stateCtr.text,
//       city: cityCtr.text,
//     );
//
//     if (signUpWatch.signupState.success?.status == ApiEndPoints.apiStatus_200 && mounted) {
//       /// Success Dialog
//       showSuccessBottomSheet(
//         context: context,
//         title: LocaleKeys.keyCongratulations.localized,
//         subTitle: LocaleKeys.keyAccountCreatedNote.localized,
//         onTap: () {
//           ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.signIn());
//         },
//       );
//     }
//   }
//
//   /// Verify Email Api Call
//   Future<void> verifyEmailApiCall() async {
//     final verifyOtpWatch = ref.watch(otpVerificationController);
//     await verifyOtpWatch.verifyEmailApi(context, email: emailCtr.text, otp: '');
//     if (verifyOtpWatch.verifyEmailApiState.success?.status == ApiEndPoints.apiStatus_200) {
//       /// Home Screen Navigation
//       ref.read(navigationStackController).push(
//             NavigationStackItem.otpVerification(
//               otpSentOn: emailCtr.text,
//               fromScreen: FromScreen.signUp,
//             ),
//           );
//     }
//   }
//
//   /// Verify Phone Api Call
//   Future<void> verifyPhoneApiCall() async {
//     final verifyOtpWatch = ref.watch(otpVerificationController);
//     await verifyOtpWatch.verifyPhoneApi(context, phoneNumber: phoneNumberCtr.text, otp: '');
//     if (verifyOtpWatch.verifyPhoneApiState.success?.status == ApiEndPoints.apiStatus_200) {
//       /// Home Screen Navigation
//       ref.read(navigationStackController).push(
//             NavigationStackItem.otpVerification(
//               otpSentOn: phoneNumberCtr.text,
//               fromScreen: FromScreen.signUp,
//             ),
//           );
//     }
//   }
//
// // /// State List Api Call
// // Future<void> stateListApiCall() async {
// //   final signUpWatch = ref.watch(signUpController);
// //   await signUpWatch.stateListApi(context);
// //   _animationController.forward();
// // }
// //
// // /// City List Api Call
// // Future<void> cityListApiCall() async {
// //   final signUpWatch = ref.watch(signUpController);
// //   if (signUpWatch.selectedState != null) {
// //     await signUpWatch.cityListApi(context);
// //   }
// // }
// }
