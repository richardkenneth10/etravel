import 'package:country_picker/country_picker.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/helpers/functions.dart' as functions;
import 'package:etravel/helpers/functions.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final _countryCode = '234'.obs;
  String get countryCode => '+${_countryCode()}';

  void openCountries(context) {
    functions.openCountries(
      context,
      (Country country) {
        _countryCode(country.phoneCode);
      },
    );
  }

  Future<void> signInWithFacebook() async {
    SafeRequest.run(() async {
      await Get.find<AuthService>().loginWithFacebook();
    }, onSuccess: (() async {
      await validateCompleteProfileAndRoute();
    }));
  }

  Future<void> signInWithGoogle() async {
    SafeRequest.run(() async {
      await Get.find<AuthService>().loginWithGoogle();
    }, onSuccess: (() async {
      await validateCompleteProfileAndRoute();
    }));
  }

  void goToPhoneScreen() {
    Get.toNamed(
      Routes.phoneScreen,
      arguments: {'countryCode': _countryCode()},
    );
  }
}
