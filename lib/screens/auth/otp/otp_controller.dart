import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:etravel/config/app_constants.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/models/user/user_data.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final phone = ''.obs;
  final updating = false.obs;

  final count = 30.obs;

  final isTimeout = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;

      if (args['phone'] != null) {
        phone(args['phone']);
      }
      if (args['update'] != null) {
        updating(args['update']);
      }
    }

    _startTimer();
  }

  Future<void> resendCode() async {
    SafeRequest.run(
      () async {
        await Get.find<AuthService>().sendOTP(phone());
      },
      onSuccess: (() {
        isTimeout(false);
        _startTimer();
      }),
    );
  }

  void _startTimer() {
    isTimeout(false);
    count(60);
    final timer = Timer.periodic(1.seconds, (Timer t) {
      if (count() == 1) {
        isTimeout(true);
        t.cancel();

        return;
      }
      count.value--;
    });
  }

  Future<void> verifyCode(String value) async {
    SafeRequest.run(() async {
      if (updating()) {
        await Get.find<UserDataService>()
            .verifyAndUpdatePhone(phone(), int.parse(value));
      } else {
        await Get.find<AuthService>()
            .verifyOTPAndLogin(phone(), int.parse(value));
      }
    }, onSuccess: () async {
      await validateCompleteProfileAndRoute();
    });
  }

  void editPhonenumber() {
    Get.offAllNamed(
      Routes.phoneScreen,
      arguments: {'phone': phone()},
    );
  }
}
