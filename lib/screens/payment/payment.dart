import 'package:get/get.dart';

import 'payment_binding.dart';
import 'payment_view.dart';

final payment = GetPage(
  name: PaymentView.name,
  page: () => const PaymentView(),
  binding: PaymentBinding(),
);
