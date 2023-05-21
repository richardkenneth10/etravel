import 'package:get/get.dart';

import 'auth_binding.dart';
import 'auth_view.dart';

final auth = GetPage(
  name: AuthView.name,
  page: () => const AuthView(),
  binding: AuthBinding(),
);
