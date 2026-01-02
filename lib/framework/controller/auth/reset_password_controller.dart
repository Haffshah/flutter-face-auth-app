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

final resetPasswordController = ChangeNotifierProvider(
  (ref) => getIt<ResetPasswordController>(),
);

@injectable
class ResetPasswordController extends ChangeNotifier {
  AuthenticationRepository authenticationRepository;


  ResetPasswordController(this.authenticationRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    resetPasswordState.isLoading = false;
    // changePasswordState.isLoading = false;
    isShowCurrentPassword = false;
    isShowConfirmPassword = false;
    isShowNewPassword = false;
    resetPasswordState.success = null;
    // changePasswordState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  bool isShowNewPassword = false;

  void updateIsShowNewPassword() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  bool isShowConfirmPassword = false;

  void updateIsShowConfirmPassword() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  bool isShowCurrentPassword = false;

  void updateIsShowCurrentPassword() {
    isShowCurrentPassword = !isShowCurrentPassword;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var resetPasswordState = UIState<CommonResponseModel>();

  /// update loading
  void updateLoadingStatus(bool value) {
    resetPasswordState.isLoading = value;
    notifyListeners();
  }

  /// Reset Password Api
  Future<void> resetPasswordApi(
    BuildContext context, {
    required String email,
    required String password,
    required String confirmPassword,
    required String otp,
  }) async {
    resetPasswordState.isLoading = true;
    resetPasswordState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'email': email,
      'otp': otp,
      'password': password,
      'confirm_password': confirmPassword,
    };

    if (context.mounted) {
      final res = await authenticationRepository.resetPasswordApi(jsonEncode(request));
      res.when(success: (data) async {
        resetPasswordState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    resetPasswordState.isLoading = false;
    notifyListeners();
  }

  // /// Change Password Api
  // var changePasswordState = UIState<CommonResponseModel>();
  //
  // Future<void> changePasswordApi(BuildContext context,
  //     {required String oldPassword, required String password, required String confirmPassword}) async {
  //   changePasswordState.isLoading = true;
  //   changePasswordState.success = null;
  //   notifyListeners();
  //
  //   Map<String, dynamic> request = {
  //     'old_password': oldPassword,
  //     'password': password,
  //     'confirm_password': confirmPassword
  //   };
  //
  //   if (context.mounted) {
  //     final res = await profileRepository.changePasswordApi(jsonEncode(request));
  //     res.when(success: (data) async {
  //       changePasswordState.success = data;
  //     }, failure: (NetworkExceptions error) {
  //       String errorMsg = NetworkExceptions.getErrorMessage(error);
  //       showMessageDialog(context, errorMsg, () {});
  //     });
  //   }
  //   changePasswordState.isLoading = false;
  //   notifyListeners();
  // }
}
