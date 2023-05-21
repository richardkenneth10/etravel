import 'package:get/get.dart';

import 'email_controller.dart';

class EmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EmailController());
  }
}
