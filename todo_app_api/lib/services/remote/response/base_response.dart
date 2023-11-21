import 'dart:core';

class BaseResponse<T> {
  int? statusCode;

  bool? success;

  T? body;

  String? message;
  
  dynamic errors;

  bool get isSuccess => success ?? false;

  BaseResponse();

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return BaseResponse<T>()
      ..statusCode = json['statusCode'] as int?
      ..success = json['success'] as bool?
      ..body = fromJsonT(json['body'])
      ..message = json['message'] as String?
      ..errors = json['errors'];
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      <String, dynamic>{
        'statusCode': statusCode,
        'success': success,
        'body': body != null ? toJsonT(body as T) : null,
        'message': message,
        'errors': errors,
      };
}