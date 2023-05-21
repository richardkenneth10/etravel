import 'package:etravel/config/routes.dart';
import 'package:etravel/models/payment/card_data.dart';
import 'package:etravel/services/payment_service.dart';
import 'package:etravel/utils/safe_request.dart';
import 'package:etravel/widgets/app_widgets/app_message.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  List<CardData> get savedCards => Get.find<PaymentService>().savedCards;

  onCardTap(String id) {
    SafeRequest.run(
      () => Get.find<PaymentService>().payWithSavedCard(
        paymentMethodId: id,
        rideId: 1,
      ),
      onSuccess: () => AppMessage.success(message: 'Payment successful'),
    );
  }

  void goToCardSavingScreen() {
    Get.toNamed(Routes.savePaymentDetailsScreen);
  }
}
