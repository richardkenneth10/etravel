import 'package:get/get.dart';

import 'save_payment_details_binding.dart';
import 'save_payment_details_view.dart';

final savePaymentDetails = GetPage(
  name: SavePaymentDetailsView.name,
  page: () => const SavePaymentDetailsView(),
  binding: SavePaymentDetailsBinding(),
);
