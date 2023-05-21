import 'package:get/get.dart';

import 'name_binding.dart';
import 'name_view.dart';

final name = GetPage(
  name: NameView.name,
  page: () => const NameView(),
  binding: NameBinding(),
);
