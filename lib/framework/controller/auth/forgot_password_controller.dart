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

final forgotPasswordController = ChangeNotifierProvider(
  (ref) => getIt<ForgotPasswordController>(),
);

@injectable
class ForgotPasswordController extends ChangeNotifier {
  AuthenticationRepository authenticationRepository;

  ForgotPasswordController(this.authenticationRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    forgotState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */
  var forgotState = UIState<CommonResponseModel>();

  /// update loading
  void updateLoadingStatus(bool value) {
    forgotState.isLoading = value;
    notifyListeners();
  }

  /// Forgot Password Api
  Future<void> forgotPasswordApi(BuildContext context, {required String email}) async {
    forgotState.isLoading = true;
    forgotState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'email': email,
    };

    if (context.mounted) {
      final res = await authenticationRepository.forgotPasswordApi(jsonEncode(request));
      res.when(success: (data) async {
        forgotState.success = data;
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }

    forgotState.isLoading = false;
    notifyListeners();
  }
}
