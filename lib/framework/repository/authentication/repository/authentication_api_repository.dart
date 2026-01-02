import 'package:face_match/framework/provider/network/network.dart';
import 'package:face_match/framework/repository/authentication/contract/authentication_repository.dart';
import 'package:face_match/framework/repository/authentication/model/city_response_model.dart';
import 'package:face_match/framework/repository/authentication/model/signin_response_model.dart';
import 'package:face_match/framework/repository/authentication/model/state_list_response_model.dart';
import 'package:face_match/framework/repository/common_response/common_response_model.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthenticationRepository, env: [development, production])
class AuthenticationApiRepository implements AuthenticationRepository {
  final DioClient apiClient;

  AuthenticationApiRepository(this.apiClient);

  /// SignIn Api
  @override
  Future<ApiResult<SignInResponseModel>> signInApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.login, request);
      SignInResponseModel responseModel = signInResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<SignInResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<SignInResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<SignInResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// SignUp Api
  @override
  Future<ApiResult<CommonResponseModel>> signUpApi(FormData formData) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.register, formData);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Register Social Api
  @override
  Future<ApiResult<SignInResponseModel>> registerSocialApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.registerSocial, request);
      SignInResponseModel responseModel = signInResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<SignInResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<SignInResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<SignInResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Forgot Password Api
  @override
  Future<ApiResult<CommonResponseModel>> forgotPasswordApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.forgotPassword, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Verify Otp Api
  @override
  Future<ApiResult<CommonResponseModel>> verifyOtpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.verifyOtp, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Verify Email Api
  @override
  Future<ApiResult<CommonResponseModel>> verifyEmailApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.verifyEmail, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Verify Phone Api
  @override
  Future<ApiResult<CommonResponseModel>> verifyPhoneApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.verifyPhone, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Reset Password Api
  @override
  Future<ApiResult<CommonResponseModel>> resetPasswordApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resetPassword, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CommonResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CommonResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CommonResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// State List Api
  @override
  Future<ApiResult<StateListResponseModel>> stateListApi() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.stateList);
      StateListResponseModel responseModel = stateListResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<StateListResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<StateListResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<StateListResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// City List From State Selection Api
  @override
  Future<ApiResult<CityListResponseModel>> cityListApi(String stateCode) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.cityList(stateCode));
      CityListResponseModel responseModel = cityListResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CityListResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CityListResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CityListResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// City Search Api
  @override
  Future<ApiResult<CityListResponseModel>> citySearchApi(String city) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.citySearch(city));
      CityListResponseModel responseModel = cityListResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult<CityListResponseModel>.success(data: responseModel);
      } else {
        return ApiResult<CityListResponseModel>.failure(
          error: NetworkExceptions.defaultError(responseModel.message ?? ''),
        );
      }
    } catch (err) {
      return ApiResult<CityListResponseModel>.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
