import 'package:get/get.dart';

import 'save_payment_details_controller.dart';

class SavePaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SavePaymentDetailsController());
  }
}
