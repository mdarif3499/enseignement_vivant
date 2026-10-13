import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/app_log.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_text/custom_text.dart';

class AppApi {
  final Dio _dio = Dio();
  final Connectivity _connectivity = Connectivity();
  final storageServices = StorageServices.instance;

  static final AppApi _instance = AppApi._internal();
  static AppApi get instance => _instance;

  AppApi._internal() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 12);
    _dio.options.connectTimeout = const Duration(seconds: 12);
    _dio.options.receiveTimeout = const Duration(seconds: 12);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            options.baseUrl = AppApiEndPoint.instance.baseUrl;
            options.contentType = 'application/json';
            options.headers["Accept"] = "application/json";

            final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
            if (connectivityResult.contains(ConnectivityResult.none)) {
              errorLog('Network Check', 'No internet connection');
              _showNoInternetDialog();
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'No internet connection',
                  type: DioExceptionType.connectionError,
                  message: 'Please check your internet connection',
                ),
              );
            }

            String token = storageServices.getToken();
            if (token.isNotEmpty && !options.headers.containsKey("Authorization")) {
              options.headers["Authorization"] = "Bearer $token";
            }

            return handler.next(options);
          } catch (e) {
            errorLog("Interceptor Request Error", e);
            return handler.next(options);
          }
        },
        onError: (error, handler) async {
          appLog("API error occurred:");
          appLog("Status code: ${error.response?.statusCode}");
          appLog("Error message: ${error.message}");

          try {
            if (error.response?.statusCode == 401) {
              final requestPath = error.requestOptions.path;
              final isAuthEndpoint = requestPath.contains('/auth/reset-password') ||
                  requestPath.contains('/auth/verify') ||
                  requestPath.contains('/auth/login') ||
                  requestPath.contains('/auth/forget-password') ||
                  requestPath.contains('/user');

              if (!isAuthEndpoint) {
                storageServices.storageClear();
                Get.offAllNamed(AppRoutes.signInScreen);
              }
              return handler.next(error);
            }
          } catch (e) {
            errorLog("error form api try and catch bloc", e);
            return handler.next(error);
          }

          return handler.next(error);
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    });
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1E1B3A),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withAlpha(30),
                ),
                child: const Icon(Icons.wifi_off_rounded, color: Colors.red, size: 32),
              ),
              const SizedBox(height: 16),
              CustomText(
                title: ConstString.noInternetConnection,
                textSize: 18,
                fontWeight: FontWeight.bold,
                textColor: ConstColor.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomText(
                title: ConstString.pleaseCheckInternet,
                textSize: 14,
                textColor: Colors.white70,
                textAlign: TextAlign.center,
                maxLine: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
                    if (connectivityResult.contains(ConnectivityResult.none)) {
                      if (Get.isDialogOpen ?? false) Get.back();
                      Future.delayed(const Duration(milliseconds: 300), () => _showNoInternetDialog());
                    } else {
                      if (Get.isDialogOpen ?? false) Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB900),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: CustomText(
                    title: ConstString.tryAgain,
                    textSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: ConstColor.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Dio get sendRequest => _dio;
}
