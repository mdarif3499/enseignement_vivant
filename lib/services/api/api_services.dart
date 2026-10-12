import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';
import '../../utils/error_log.dart';
import '../storage_services/get_storage_services.dart';
import 'api.dart';

class ApiServices {
  ApiServices._privateConstructor();
  static final ApiServices _instance = ApiServices._privateConstructor();
  static ApiServices get instance => _instance;

  final _storageServices = StorageServices.instance;
  final _snackBar = AppSnackBar.instance;

  Future<dynamic> putServices({required String url, dynamic body, int statusCode = 200, Map<String, dynamic>? query}) async {
    try {
      final response = await AppApi.instance.sendRequest.put(url, data: body, queryParameters: query);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      _snackBar.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> postServices({required String url, dynamic body, int statusCodeStart = 200, int statusCodeEnd = 299, Map<String, dynamic>? queryParameters}) async {
    try {
      final dynamic response = await AppApi.instance.sendRequest.post(url, data: body, queryParameters: queryParameters);
      if (response.statusCode != null && response.statusCode! >= statusCodeStart && response.statusCode! <= statusCodeEnd) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      _snackBar.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> getServices(String url, {int statusCode = 200, Map<String, dynamic>? queryParameters, dynamic body}) async {
    try {
      final response = await AppApi.instance.sendRequest.get(url, queryParameters: queryParameters, data: body);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      _snackBar.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> patchServices({required String url, Object? body, int statusCode = 200, Map<String, dynamic>? query, Options? options}) async {
    try {
      final response = await AppApi.instance.sendRequest.patch(url, data: body, queryParameters: query, options: options);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        _snackBar.error("Unexpected response: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> deleteServices({required String url, Object? body, int statusCode = 200, Map<String, dynamic>? query, Options? options}) async {
    try {
      final response = await AppApi.instance.sendRequest.delete(url, data: body, queryParameters: query, options: options);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        _snackBar.error("Unexpected response: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> multipartServices({
    required String url,
    Map<String, dynamic>? body,
    List<String>? filePath,
    List<String>? fileKey,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
  }) async {
    try {
      FormData formData = FormData();
      if (body != null) {
        body.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }
      if (filePath != null && fileKey != null && filePath.length == fileKey.length) {
        for (int i = 0; i < filePath.length; i++) {
          File file = File(filePath[i]);
          if (file.existsSync()) {
            formData.files.add(
              MapEntry(
                fileKey[i],
                await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
              ),
            );
          }
        }
      }
      final dynamic response = await AppApi.instance.sendRequest.post(url, data: formData);
      if (response.statusCode != null && response.statusCode! >= statusCodeStart && response.statusCode! <= statusCodeEnd) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  dynamic _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.data != null && e.response?.data["message"] != null) {
        _snackBar.error("${e.response?.data["message"]}");
      } else {
        _snackBar.error("Server Error: ${e.response?.statusCode}");
      }
    } else {
      errorLog('api dio exception', e.message ?? e.type.toString());
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
        _snackBar.error("Cannot connect to server. Please check IP/Network.");
      } else {
        _snackBar.error("API Error: ${e.type}");
      }
    }
    return null;
  }
}
