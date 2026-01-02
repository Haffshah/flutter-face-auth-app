import 'dart:io';

import 'package:dio/dio.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/api_result.dart';
import 'package:face_match/framework/provider/network/network_exceptions.dart';
import 'package:face_match/framework/repository/authentication/contract/authentication_repository.dart';
import 'package:face_match/framework/repository/common_response/common_response_model.dart';
import 'package:face_match/framework/utils/ui_state.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final signUpController = ChangeNotifierProvider((ref) => getIt<SignUpController>());

@injectable
class SignUpController extends ChangeNotifier {
  AuthenticationRepository authenticationRepository;

  SignUpController(this.authenticationRepository);

  /// Step of Sign Up
  int currentStep = 1;

  void updateCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  /// Terms and Conditions Accepted
  bool isTermsAccepted = false;

  void updateIsTermsAccepted(bool value) {
    isTermsAccepted = value;
    notifyListeners();
  }

  /// Business Type
  String businessType = businessTypeService;

  void updateBusinessType(String type) {
    businessType = type;
    notifyListeners();
  }

  //
  // /// Current Location
  // LatLng? currentLocation;
  //
  // /// Get Current Location
  // Future<LatLng?> getCurrentLocationForMap() async {
  //   updateLoadingStatus(true);
  //
  //   if (await handleLocationPermission()) {
  //     final position = await getCurrentLocation();
  //     showLog('position $position');
  //     currentLocation = LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
  //     updateLoadingStatus(false);
  //     notifyListeners();
  //     return currentLocation;
  //   } else {
  //     showLog('Location permission denied');
  //     updateLoadingStatus(false);
  //     return null;
  //   }
  // }

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;
    isPasswordVisible = false;
    profileImage = null;
    isEmailVerified = false;
    isPhoneVerified = false;
    verifiedEmail = '';
    verifiedPhone = '';
    businessType = 'Service';
    isTermsAccepted = false;
    currentStep = 1;
    // stateList.clear();
    // cityList.clear();
    // selectedCity = null;
    // selectedState = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Is Password Visible
  bool isPasswordVisible = false;

  void updateIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  /// Is Confirm Password Visible
  bool isConfirmPasswordVisible = false;

  void updateIsConfirmPasswordVisible() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Profile Image
  File? profileImage;

  void updateProfileImage(File? file) {
    profileImage = file;
    notifyListeners();
  }

  // /// State List
  // List<StateData> stateList = [];
  //
  // /// City List
  // List<String> cityList = [];
  //
  // StateData? selectedState;
  // String? selectedCity;
  //
  // updateSelectedState(BuildContext context, StateData value) {
  //   selectedState = value;
  //   selectedCity = null;
  //   cityListApi(context);
  //   notifyListeners();
  // }
  //
  // updateSelectedCity(BuildContext context, String value) {
  //   selectedCity = value;
  //   notifyListeners();
  // }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// For Used In Email Verification From Server
  bool isEmailVerified = false;
  String verifiedEmail = '';

  void updateIsEmailVerified(String email, bool value) {
    isEmailVerified = value;
    verifiedEmail = email;
    notifyListeners();
  }

  /// For Used IN Mobile Number Verification From Server
  bool isPhoneVerified = false;
  String verifiedPhone = '';

  void updateIsPhoneVerified(String mobile, bool value) {
    isPhoneVerified = value;
    verifiedPhone = mobile;
    notifyListeners();
  }

  ///------------------------------Api Properties----------------------------///

  var signupState = UIState<CommonResponseModel>();

  /// SignUp Api
  Future<void> signUpApi(
    BuildContext context, {
    required String companyName,
    required String email,
    required String password,
    required String phoneNo,
    required String address,
    required String state,
    required String city,
  }) async {
    signupState.isLoading = true;
    signupState.success = null;
    notifyListeners();

    FormData formData;
    MultipartFile? uploadedImagePhoto;

    String fileName = "${generateFileName()}.${profileImage?.path.split(".").last}";
    if (profileImage != null) {
      uploadedImagePhoto = await MultipartFile.fromFile(profileImage?.path ?? '', filename: fileName);
    }

    if (profileImage?.path != '' && uploadedImagePhoto != null) {
      formData = FormData.fromMap({
        'company_name': companyName,
        'company_type': businessType.toLowerCase(),
        'email': email,
        'phone_code': phoneCode,
        'phone_number': phoneNo,
        'password': password,
        'logo': uploadedImagePhoto,
        'address': address,
        'state': state,
        'city': city,
        // 'latitude': currentLocation?.latitude ?? 0.0,
        // 'longitude': currentLocation?.longitude ?? 0.0,
      });
    } else {
      formData = FormData.fromMap({
        'company_name': companyName,
        'company_type': businessType.toLowerCase(),
        'email': email,
        'phone_code': phoneCode,
        'phone_number': phoneNo,
        'password': password,
        'address': address,
        'state': state,
        'city': city,
        // 'latitude': currentLocation?.latitude ?? 0.0,
        // 'longitude': currentLocation?.longitude ?? 0.0,
      });
    }

    if (context.mounted) {
      final res = await authenticationRepository.signUpApi(formData);
      res.when(
        success: (data) async {
          signupState.success = data;
        },
        failure: (NetworkExceptions error) {
          String errorMsg = NetworkExceptions.getErrorMessage(error);
          showMessageDialog(context, errorMsg, () {});
        },
      );
    }
    signupState.isLoading = false;
    notifyListeners();
  }
}
