import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'error_log.dart';

void appLog(dynamic message) {
  try {
    if (kDebugMode) {
      debugPrint("""
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

$message

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
""");
    } else {
      log("$message");
    }
  } catch (e) {
    errorLog("app log", e);
  }
}
