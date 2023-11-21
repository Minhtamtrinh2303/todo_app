import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:todo_app_api/services/local/shared_prefs.dart';

class ApiServices {
  ApiServices._();

  static final httpLog = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  /// GET method
  static Future<http.Response> getData(String url,
      {Map<String, dynamic>? queryParams}) async {
    String? token = SharedPrefs.token;

// {deleted: true}
    String query = queryParams?.entries
            .map((e) => '${e.key}=${e.value}')
            .toList()
            .join('&') ??
        '';
    final requestUrl = query.isEmpty ? url : '$url?$query';
    http.Response response = await httpLog.get(Uri.parse(requestUrl), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return response;
  }

  /// POST method
  static Future<http.Response> postData(String url, {dynamic body}) async {
    String? token = SharedPrefs.token;
    http.Response response = await httpLog.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    return response;
  }

  /// PUT method
  static Future<http.Response> put(String url, {dynamic body}) async {
    String? token = SharedPrefs.token;
    final response = await httpLog.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    return response;
  }

  /// DELETE method
  static Future<http.Response> deleteData(String url, {dynamic body}) async {
    String? token = SharedPrefs.token;
    final response = await httpLog.delete(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    return response;
  }

  /// POST method with multipart/form-data
  static Future<http.Response> postFile(String url, File file) async {
    final reponse = multipart(
      method: 'POST',
      url: url,
      files: [
        await http.MultipartFile.fromPath('file', file.path),
      ],
    );

    return reponse;
  }

  /// multipart method
  static Future<http.Response> multipart({
    required String method,
    required String url,
    required List<http.MultipartFile> files,
  }) async {
    String? token = SharedPrefs.token;
    final request = http.MultipartRequest(method, Uri.parse(url));

    request.files.addAll(files);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final stream = await request.send();

    return http.Response.fromStream(stream).then((response) {
      if (response.statusCode == 200) {
        log('response ${response.body}');
        return response;
      }
      throw Exception('Failed to load data');
    });
  }
}
