import 'package:get/get.dart';

import 'setup_profile_controller.dart';

class SetupProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SetupProfileController());
  }
}
