import 'package:get/get.dart';

import 'otp_binding.dart';
import 'otp_view.dart';

final otp = GetPage(
  name: OTPView.name,
  page: () => const OTPView(),
  binding: OTPBinding(),
);
