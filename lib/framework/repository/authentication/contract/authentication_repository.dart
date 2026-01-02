import 'package:dio/dio.dart';
import 'package:face_match/framework/provider/network/api_result.dart';
import 'package:face_match/framework/repository/authentication/model/city_response_model.dart';
import 'package:face_match/framework/repository/authentication/model/signin_response_model.dart';
import 'package:face_match/framework/repository/authentication/model/state_list_response_model.dart';
import 'package:face_match/framework/repository/common_response/common_response_model.dart';

import 'package:face_match/framework/repository/authentication/model/signin_response_model.dart' show SignInResponseModel;

abstract class AuthenticationRepository {
  ///SignIn Api
  Future<ApiResult<SignInResponseModel>> signInApi(String request);

  /// SignUp Api
  Future<ApiResult<CommonResponseModel>> signUpApi(FormData formData);

  /// Register Social Api
  Future<ApiResult<SignInResponseModel>> registerSocialApi(String request);

  /// Forgot Password Api
  Future<ApiResult<CommonResponseModel>> forgotPasswordApi(String request);

  /// Verify Otp Api
  Future<ApiResult<CommonResponseModel>> verifyOtpApi(String request);

  /// Verify Email Api
  Future<ApiResult<CommonResponseModel>> verifyEmailApi(String request);

  /// Verify Phone Api
  Future<ApiResult<CommonResponseModel>> verifyPhoneApi(String request);

  /// Reset Password Api
  Future<ApiResult<CommonResponseModel>> resetPasswordApi(String request);

  /// State List Api
  Future<ApiResult<StateListResponseModel>> stateListApi();

  /// City List Api
  Future<ApiResult<CityListResponseModel>> cityListApi(String stateCode);

  /// City Search Api
  Future<ApiResult<CityListResponseModel>> citySearchApi(String city);
}
