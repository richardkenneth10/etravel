import 'package:get/get.dart';

import 'phone_binding.dart';
import 'phone_view.dart';

final phone = GetPage(
  name: PhoneView.name,
  page: () => const PhoneView(),
  binding: PhoneBinding(),
);
