import 'package:get/get.dart';

import 'email_binding.dart';
import 'email_view.dart';

final email = GetPage(
  name: EmailView.name,
  page: () => const EmailView(),
  binding: EmailBinding(),
);
