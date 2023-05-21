import 'package:get/get.dart';

import 'home_binding.dart';
import 'home_view.dart';

final home = GetPage(
  name: HomeView.name,
  page: () => const HomeView(),
  binding: HomeBinding(),
);
