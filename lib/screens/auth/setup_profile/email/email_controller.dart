import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailController extends GetxController {
  // final _auth = Get.find<FirebaseAuthService>();

  final textController = TextEditingController();

  final email = ''.obs;

  var focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
  }

  void clearText() {
    email('');
    textController.text = '';
    focusNode.nextFocus();
  }

  void onEmailChanged(String value) {
    email(value);
  }

  Future<void> saveEmail() async {
    SafeRequest.run(
      () async => await Get.find<UserDataService>().updateEmail(email()),
      onSuccess: validateCompleteProfileAndRoute,
    );
  }
}
