import 'package:country_picker/country_picker.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart' as functions;
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneController extends GetxController {
  final _auth = Get.find<AuthService>();

  final textController = TextEditingController();

  final updating = false.obs;

  final phone = ''.obs;

  final _countryCode = '234'.obs;

  final focusNode = FocusNode();

  String get countryCode => '+${_countryCode()}';

  openCountries(BuildContext context) {
    functions.openCountries(
      context,
      (Country country) {
        print('Select country: ${country.displayName}');
        _countryCode(country.phoneCode);
      },
    );
  }

  void clearText() {
    phone('');
    textController.text = '';
    focusNode.nextFocus();
  }

  Future<void> sendOTP() async {
    SafeRequest.run(
      () async {
        await Get.find<AuthService>().sendOTP(phone());
      },
      onSuccess: (() => Get.toNamed(
            Routes.otpScreen,
            arguments: {
              'phone': phone(),
              "update": updating(),
            },
          )),
    );
  }

  void onPhoneChanged(String value) {
    phone(value);
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;

      if (args['countryCode'] != null) {
        _countryCode(args['countryCode']);
      }
      if (args['update'] != null) {
        updating(args['update']);
      }
      if (args['phone'] != null) {
        phone(args['phone']);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
  }
}
