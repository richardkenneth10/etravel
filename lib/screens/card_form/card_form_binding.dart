import 'package:get/get.dart';

import 'card_form_controller.dart';

class CardFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CardFormController());
  }
}
