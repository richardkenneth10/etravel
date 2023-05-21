import 'dart:async';

import 'package:etravel/config/app_constants.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/services/location_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class InitialController extends GetxController {
  // final _auth = Get.find<FirebaseAuthService>();
  final _location = Get.find<LocationService>();

  @override
  Future<void> onInit() async {
    super.onInit();

    StreamSubscription<Position?>? listener;

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    final user = await secureStorage.read(key: USER_PROFILE_KEY);

    if (user == null) {
      listener = _location.currentPosition.listen((p0) {
        if (p0 != null) {
          FlutterNativeSplash.remove();
          listener!.cancel();
          Get.toNamed(Routes.authScreen);
        }
      });
    } else {
      listener = _location.currentPosition.listen((p0) {
        if (p0 != null) {
          FlutterNativeSplash.remove();
          listener!.cancel();
          Get.toNamed(Routes.homeScreen);
        }
      });
    }
  }
}
