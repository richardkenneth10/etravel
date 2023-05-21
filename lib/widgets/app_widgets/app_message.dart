import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMessage {
  static Future<void> loading() async {
    return showDialog(
      context: (Get.context ?? Get.overlayContext)!,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  static success({required String message}) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.primary,
    );
  }

  static error({required String message}) {
    return Get.rawSnackbar(
        message: message, backgroundColor: Colors.red, duration: 20.seconds);
  }
}
