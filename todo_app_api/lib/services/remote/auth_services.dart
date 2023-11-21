import 'dart:convert';
import 'package:todo_app_api/constants/app_constant.dart';
import 'package:todo_app_api/models/app_user_model.dart';
import 'package:todo_app_api/services/remote/api_services.dart';
import 'package:todo_app_api/services/remote/body/change_password_body.dart';
import 'package:todo_app_api/services/remote/body/login_body.dart';
import 'package:todo_app_api/services/remote/body/new_password_body.dart';
import 'package:todo_app_api/services/remote/body/register_body.dart';
import 'package:todo_app_api/services/remote/response/base_response.dart';

abstract class ImplAuthServices {
  Future<BaseResponse<dynamic>> sendOtp(String email);
  Future<BaseResponse<AppUserModel>> register(RegisterBody body);
  Future<BaseResponse<dynamic>> login(LoginBody body);
  Future<BaseResponse<dynamic>> postForgotPassword(NewPasswordBody body);
  Future<BaseResponse<dynamic>> changePassword(ChangePasswordBody body);
}

class AuthServices implements ImplAuthServices {
  @override
  Future<BaseResponse<dynamic>> sendOtp(String email) async {
    const url = AppConstant.endPointOtp;
    final response = await ApiServices.postData(
      url,
      body: jsonEncode({'email': email}),
    );

    Map<String, dynamic> result = jsonDecode(response.body);
    return BaseResponse<dynamic>.fromJson(result, (json) => json as dynamic);
  }

  @override
  Future<BaseResponse<AppUserModel>> register(RegisterBody body) async {
    const url = AppConstant.endPointAuthRegister;
    final response = await ApiServices.postData(
      url,
      body: jsonEncode(body.toJson()),
    );

    Map<String, dynamic> result = jsonDecode(response.body);
    return BaseResponse.fromJson(
        result, (json) => AppUserModel.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<BaseResponse<dynamic>> login(LoginBody body) async {
    const url = AppConstant.endPointLogin;
    final response = await ApiServices.postData(
      url,
      body: jsonEncode(body.toJson()),
    );

    Map<String, dynamic> result = jsonDecode(response.body);
    return BaseResponse.fromJson(result, (json) => json as dynamic);
  }

  @override
  Future<BaseResponse<dynamic>> postForgotPassword(NewPasswordBody body) async {
    const url = AppConstant.endPointForgotPassword;
    final response = await ApiServices.postData(
      url,
      body: jsonEncode(body.toJson()),
    );

    final result = jsonDecode(response.body);
    return BaseResponse.fromJson(result, (json) => json as dynamic);
  }

  @override
  Future<BaseResponse> changePassword(ChangePasswordBody body) async {
    const url = AppConstant.endPointChangePassword;
    final response =
        await ApiServices.put(url, body: jsonEncode(body.toJson()));
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse.fromJson(
      result,
      (json) => json as dynamic,
    );
  }
}
