import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:etravel/config/app_constants.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/models/user/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

void openCountries(
  BuildContext context,
  void Function(Country) onSelect,
) {
  showCountryPicker(
    context: context,
    showPhoneCode: true,
    onSelect: onSelect,
  );
}

Future<void> validateCompleteProfileAndRoute() async {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final user = await secureStorage.read(key: USER_PROFILE_KEY);

  if (user == null) {
    Get.toNamed(Routes.authScreen);
    return;
  }

  final userJSON = json.decode(user) as Map<String, dynamic>;
  final userData = UserData.fromJson(userJSON);

  if (userData.phone.isEmpty) {
    Get.offAllNamed(Routes.phoneScreen, arguments: {'update': true});
  } else if ((userData.firstName.isEmpty && userData.lastName.isEmpty) &&
      userData.email.isEmpty) {
    Get.offAllNamed(Routes.setupProfileScreen);
  } else if (userData.email.isEmpty) {
    Get.offAllNamed(Routes.emailScreen);
  } else if ((userData.firstName.isEmpty && userData.lastName.isEmpty)) {
    Get.offAllNamed(Routes.nameScreen);
  } else {
    Get.offAllNamed(Routes.homeScreen);
  }
}
