import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/api_result.dart';
import 'package:face_match/framework/provider/network/network_exceptions.dart';
import 'package:face_match/framework/repository/authentication/contract/authentication_repository.dart';
import 'package:face_match/framework/repository/authentication/model/signin_response_model.dart';
import 'package:face_match/framework/utils/local_storage/session.dart';
import 'package:face_match/framework/utils/ui_state.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';

final signInController = ChangeNotifierProvider(
  (ref) => getIt<SignInController>(),
);

@injectable
class SignInController extends ChangeNotifier {
  AuthenticationRepository authenticationRepository;

  SignInController(this.authenticationRepository);

  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isPasswordVisible = false;
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    try {
      updateLoadingStatus(true);
      // Implement sign in logic here
    } catch (e) {
      commonToaster(e.toString());
    } finally {
      updateLoadingStatus(false);
    }
  }

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

/*
  /// ---------------------------- Api Integration ---------------------------------///
   */
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var signInApiState = UIState<SignInResponseModel>();

  /// Sign in Api
  Future<void> signInApi(BuildContext context, {required String email, required String password}) async {
    signInApiState.isLoading = true;
    signInApiState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'email': email,
      'password': password,
      'device_token': SessionHelper.deviceFCMToken,
      'device_type': getCurrentDeviceType(),
    };

    if (context.mounted) {
      final ApiResult<SignInResponseModel> res = await authenticationRepository.signInApi(jsonEncode(request));
      res.when(success: (SignInResponseModel data) async {
        signInApiState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    signInApiState.isLoading = false;
    notifyListeners();
  }
}
