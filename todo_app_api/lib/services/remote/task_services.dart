import 'dart:convert';
import 'package:todo_app_api/constants/app_constant.dart';
import 'package:todo_app_api/models/task_model.dart';
import 'package:todo_app_api/services/remote/api_services.dart';
import 'package:todo_app_api/services/remote/body/delete_task_body.dart';
import 'package:todo_app_api/services/remote/body/task_body.dart';
import 'package:todo_app_api/services/remote/response/base_response.dart';
import 'package:todo_app_api/services/remote/response/pagination_response.dart';

abstract class ImplTaskServices {
  Future<BaseResponse<Pagination<TaskModel>>> getListTask(
      {Map<String, dynamic>? queryParams});
  Future<BaseResponse<TaskModel>> createTask(TaskBody body);
  Future<BaseResponse<TaskModel>> updateTask(TaskBody body);
  Future<BaseResponse<dynamic>> deleteTask(String id);
  Future<BaseResponse<dynamic>> deleteMultipleTask(DeleteTaskBody body);
  Future<BaseResponse<dynamic>> restoreMultipleTask(DeleteTaskBody body);
}

class TaskServices implements ImplTaskServices {
  @override
  Future<BaseResponse<Pagination<TaskModel>>> getListTask(
      {Map<String, dynamic>? queryParams}) async {
    const url = AppConstant.endPointGetListTask;

    final response = await ApiServices.getData(url, queryParams: queryParams);

    Map<String, dynamic> result = jsonDecode(response.body);

    final value = BaseResponse<Pagination<TaskModel>>.fromJson(
      result,
      (json) => Pagination<TaskModel>.fromJson(
        json as Map<String, dynamic>,
        (json) => TaskModel.fromJson(json as Map<String, dynamic>),
      ),
    );

    return value;
  }

  @override
  Future<BaseResponse<TaskModel>> createTask(TaskBody body) async {
    const url = AppConstant.endPointTaskCreate;
    final response = await ApiServices.postData(
      url,
      body: jsonEncode(body.toJson()),
    );
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<TaskModel>.fromJson(
      result,
      (json) => TaskModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<TaskModel>> updateTask(TaskBody body) async {
    final url = '${AppConstant.endPointTaskUpdate}/${body.id}';
    final response = await ApiServices.put(
      url,
      body: jsonEncode(body.toJson()),
    );

    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<TaskModel>.fromJson(
      result,
      (json) => TaskModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse> deleteTask(String id) async {
    final url = '${AppConstant.endPointTaskDelete}/$id';
    final response = await ApiServices.deleteData(url);
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<dynamic>.fromJson(
      result,
      (json) => json as dynamic,
    );
  }

  @override
  Future<BaseResponse> deleteMultipleTask(DeleteTaskBody body) async {
    const url = AppConstant.endPointTaskMultipleDelete;
    final response =
        await ApiServices.deleteData(url, body: jsonEncode(body.toJson()));
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<dynamic>.fromJson(
      result,
      (json) => json as dynamic,
    );
  }

  @override
  Future<BaseResponse> restoreMultipleTask(DeleteTaskBody body) async {
    const url = AppConstant.endPointTaskMultipleRestore;
    final response =
        await ApiServices.put(url, body: jsonEncode(body.toJson()));
    Map<String, dynamic> result = jsonDecode(response.body);

    return BaseResponse<dynamic>.fromJson(
      result,
      (json) => json as dynamic,
    );
  }
}
