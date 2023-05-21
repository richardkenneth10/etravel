import 'package:get/get.dart';

import 'setup_profile_binding.dart';
import 'setup_profile_view.dart';

final setupProfile = GetPage(
  name: SetupProfileView.name,
  page: () => const SetupProfileView(),
  binding: SetupProfileBinding(),
);
