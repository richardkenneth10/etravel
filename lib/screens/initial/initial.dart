import 'package:get/get.dart';

import 'initial_binding.dart';
import 'initial_view.dart';

final initial = GetPage(
  name: InitialView.name,
  page: () => const InitialView(),
  binding: InitialBinding(),
);
