import 'dart:convert';

import 'package:face_match/framework/provider/network/api_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/network_exceptions.dart';
import 'package:face_match/framework/repository/authentication/contract/authentication_repository.dart';
import 'package:face_match/framework/repository/common_response/common_response_model.dart';
import 'package:face_match/framework/utils/ui_state.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';

final otpVerificationController = ChangeNotifierProvider(
  (ref) => getIt<OtpVerificationController>(),
);

@injectable
class OtpVerificationController extends ChangeNotifier {
  AuthenticationRepository authenticationRepository;

  OtpVerificationController(this.authenticationRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    secondsRemaining = 60;
    enableResend = false;
    currentText = '';
    otpComplete = false;
    verifyOtpState.success = null;
    verifyEmailApiState.success = null;
    verifyPhoneApiState.success = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  ///variables for timer
  int secondsRemaining = 60;
  bool enableResend = false;

  ///current text in otp field
  String currentText = '';
  bool otpComplete = false;

  void otpVerifyTimer() {
    if (secondsRemaining != 0) {
      secondsRemaining--;
    } else {
      enableResend = true;
    }
    notifyListeners();
  }

  void resendCode() {
    secondsRemaining = 60;
    enableResend = false;
    notifyListeners();
  }

  void changeOtpField(String value) {
    currentText = value;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var verifyOtpState = UIState<CommonResponseModel>();

  /// update loading
  void updateLoadingStatus(bool value) {
    verifyOtpState.isLoading = value;
    notifyListeners();
  }

  /// Verify Api
  Future<void> verifyOtpApi(BuildContext context, {required String email, required String otp}) async {
    verifyOtpState.isLoading = true;
    verifyOtpState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'email': email,
      'otp': otp,
    };

    if (context.mounted) {
      final res = await authenticationRepository.verifyOtpApi(jsonEncode(request));
      res.when(success: (data) async {
        verifyOtpState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    verifyOtpState.isLoading = false;
    notifyListeners();
  }

  var verifyEmailApiState = UIState<CommonResponseModel>();

  /// Verify Email Api
  Future<void> verifyEmailApi(BuildContext context, {required String email, required String otp}) async {
    verifyEmailApiState.isLoading = true;
    verifyEmailApiState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {};

    /// For Verify Email
    if (otp != '') {
      request = {
        'email': email,
        'otp': otp,
      };
    }

    /// To Sent Verification code on Email
    else {
      request = {
        'email': email,
      };
    }

    if (context.mounted) {
      final res = await authenticationRepository.verifyEmailApi(jsonEncode(request));
      res.when(success: (data) async {
        verifyEmailApiState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    verifyEmailApiState.isLoading = false;
    notifyListeners();
  }

  var verifyPhoneApiState = UIState<CommonResponseModel>();

  /// Verify Phone Api
  Future<void> verifyPhoneApi(BuildContext context, {required String phoneNumber, required String otp}) async {
    verifyPhoneApiState.isLoading = true;
    verifyPhoneApiState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {};

    /// For Verify Email
    if (otp != '') {
      request = {
        'phone_number': phoneNumber,
        'otp': otp,
      };
    }

    /// To Sent Verification code on Email
    else {
      request = {
        'phone_number': phoneNumber,
      };
    }

    if (context.mounted) {
      final res = await authenticationRepository.verifyPhoneApi(jsonEncode(request));
      res.when(success: (data) async {
        verifyPhoneApiState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    verifyPhoneApiState.isLoading = false;
    notifyListeners();
  }
}
