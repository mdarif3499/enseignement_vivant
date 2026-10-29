import 'package:flutter/foundation.dart';
import '../utils/error_log.dart';

class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;
  final String domain = _getDomain();
  final String baseUrl = "${_getDomain()}/api/v1";
  final String imageBaseUrl = "${_getDomain()}/files";

  String login = "/auth/login";
  String userSignUp = "/user";
  String authForgotPassword = "/auth/forget-password";
  String authVerifyEmail = "/auth/verify-email";
  String authVerifyOtp = "/auth/verify-otp";
  String authVerifyPhone = "/auth/verify-account";
  String userResendOtp = "/auth/resend-otp";
  String authResetPassword = "/auth/reset-password";
  String changePassword = "/auth/change-password";
  String updateProfile = "/user/profile";
  String deleteAccount = "/user/account-delete";
  String prayer = "/prayer";
  String audio = "/audio";
  String teaching = "/teaching";
  String imageEndpoint = "/image";
  String encouragement = "/encouragement";
  String verseEndpoint = "/verse";
  String favoriteEndpoint = "/favorite";
  String notificationEndpoint = "/notification";
}

String _getDomain() {
  String liveServer = "http://10.10.26.164:5010";
  String localServer = "http://10.10.26.164:5010";

  try {
    if (kDebugMode) {
      return localServer;
    }
    return liveServer;
  } catch (e) {
    errorLog("_getDomain", e);
    return liveServer;
  }
}
