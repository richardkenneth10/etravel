import 'package:etravel/services/api.dart';
import 'package:etravel/services/etravel_db.dart';
import 'package:etravel/services/location_service.dart';
import 'package:etravel/services/payment_service.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:get/get.dart';

import 'services/auth_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final auth = AuthService();
    Get.put(AuthService(), permanent: true);
    Get.put(ETravelDB(), permanent: true);
    Get.put(LocationService(), permanent: true);
    Get.lazyPut(() => APIService(), fenix: true);
    Get.lazyPut(() => PaymentService(), fenix: true);
    Get.lazyPut(() => UserDataService(), fenix: true);
  }
}
