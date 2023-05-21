import 'dart:async';
import 'dart:developer';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  late bool _serviceEnabled;
  late LocationPermission _permission;
  late final StreamSubscription<Position> positionStream;

  final currentPosition = Rx<Position?>(null);
  final lastKnownPosition = Rx<Position?>(null);

  bool get permissionGranted =>
      !isLoading() &&
      (_serviceEnabled &&
          (_permission != LocationPermission.denied ||
              _permission != LocationPermission.deniedForever));

  final isLoading = true.obs;

  Future<void> _handlePermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      Get.rawSnackbar(
        message:
            'You will need to enable location service to continue.\nTap to open Location Settings',
        duration: 5.seconds,
        onTap: (_) => Geolocator.openLocationSettings(),
      );
      return;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.deniedForever) {
        FlutterNativeSplash.remove();
        Get.rawSnackbar(
          message:
              'ETravel Cab needs your location permission. You can Allow it in the App settings\nTap to open App Settings',
          duration: 5.seconds,
          onTap: (_) => Geolocator.openAppSettings(),
        );
        Future.delayed(3.seconds, Get.back);
        return;
      }

      if (_permission == LocationPermission.denied) {
        FlutterNativeSplash.remove();
        Get.rawSnackbar(
          message: 'ETravel Cab needs your location permission.',
        );
        Future.delayed(3.seconds, Get.back);
        return;
      }
    }
    currentPosition(await Geolocator.getCurrentPosition());
    FlutterNativeSplash.remove();
  }

  @override
  void onInit() async {
    super.onInit();
    await _handlePermission();

    lastKnownPosition(await Geolocator.getLastKnownPosition());
    isLoading(false);

    positionStream = Geolocator.getPositionStream().listen((position) {
      currentPosition(position);
      log('position changed');
    });
  }

  @override
  void onClose() {
    super.onClose();

    positionStream.cancel();
  }
}
