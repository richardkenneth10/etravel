import 'package:etravel/services/payment_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:etravel/widgets/app_widgets/app_message.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class SavePaymentDetailsController extends GetxController {
  final cardFormController = CardFormEditController();
  Future<void> saveCard() async {
    if (!cardFormController.details.complete) {
      Get.rawSnackbar(message: 'All fields need to be filled');
      return;
    }
    SafeRequest.run(
      () async {
        await Get.find<PaymentService>().saveCardDetails();
      },
      onSuccess: () => AppMessage.success(message: 'card saved'),
    );
  }
}
