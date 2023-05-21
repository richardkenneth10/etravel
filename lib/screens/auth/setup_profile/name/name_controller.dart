import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameController extends GetxController {
  // final _auth = Get.find<FirebaseAuthService>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final firstName = ''.obs;
  final lastName = ''.obs;

  var firstFocusNode = FocusNode();
  var lastFocusNode = FocusNode();

  bool get emptyFields => firstName().isEmpty || lastName().isEmpty;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  void onLastNameChanged(String value) {
    lastName(value);
  }

  void onFirstNameChanged(String value) {
    firstName(value);
  }

  void clearLastName() {
    lastName('');
    lastNameController.text = '';
    firstFocusNode.nextFocus();
  }

  void clearFirstName() {
    firstName('');
    firstNameController.text = '';
    lastFocusNode.nextFocus();
  }

  Future<void> saveNames() async {
    SafeRequest.run(
      () async => await Get.find<UserDataService>().updateNames(
        firstName(),
        lastName(),
      ),
      onSuccess: validateCompleteProfileAndRoute,
    );
  }
}
