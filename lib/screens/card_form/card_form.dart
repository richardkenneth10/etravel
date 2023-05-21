import 'package:get/get.dart';

import 'card_form_binding.dart';
import 'card_form_view.dart';

final cardForm = GetPage(
  name: CardFormView.name,
  page: () => const CardFormView(),
  binding: CardFormBinding(),
);
