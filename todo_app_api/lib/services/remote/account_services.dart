import 'dart:convert';
import 'dart:io';
import 'package:todo_app_api/constants/app_constant.dart';
import 'package:todo_app_api/models/app_user_model.dart';
import 'package:todo_app_api/models/file_model.dart';
import 'package:todo_app_api/services/remote/api_services.dart';
import 'package:todo_app_api/services/remote/body/profile_body.dart';
import 'package:todo_app_api/services/remote/response/base_response.dart';

abstract class ImplAccountServices {
  Future<BaseResponse<AppUserModel>> getProfile();
  Future<BaseResponse<dynamic>> updateProfile(ProfileBody body);
  Future<BaseResponse<FileModel>> uploadFile(File file);
}

class AccountServices implements ImplAccountServices {
  @override
  Future<BaseResponse<AppUserModel>> getProfile() async {
    const url = AppConstant.endPointGetProfile;
    final response = await ApiServices.getData(url);
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<AppUserModel>.fromJson(
      result,
      (json) => AppUserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse> updateProfile(ProfileBody body) async {
    const url = AppConstant.endPointUpdateProfile;
    final response =
        await ApiServices.put(url, body: jsonEncode(body.toJson()));
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse.fromJson(
      result,
      (json) => json as dynamic,
    );
  }

  @override
  Future<BaseResponse<FileModel>> uploadFile(File file) async {
    const url = AppConstant.endPointUploadFile;
    final response = await ApiServices.postFile(url, file);
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<FileModel>.fromJson(
      result,
      (json) => FileModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
