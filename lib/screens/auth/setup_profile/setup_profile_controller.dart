import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:etravel/config/app_constants.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart' as functions;
import 'package:etravel/helpers/functions.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/models/user/user_data.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SetupProfileController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final _countryCode = '234'.obs;
  String get countryCode => '+${_countryCode()}';

  Future<void> continueWithFacebook() async {
    SafeRequest.run(
      () async {
        await Get.find<UserDataService>().updateProfileWithFacebook();
      },
      onSuccess: (() async {
        await validateCompleteProfileAndRoute();
      }),
    );
  }

  Future<void> continueWithGoogle() async {
    SafeRequest.run(
      () async {
        await Get.find<UserDataService>().updateProfileWithGoogle();
      },
      onSuccess: (() async {
        await validateCompleteProfileAndRoute();
      }),
    );
  }

  void goToEmailScreen() {
    Get.toNamed(
      Routes.emailScreen,
    );
  }
}
