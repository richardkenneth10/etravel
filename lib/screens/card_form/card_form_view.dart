import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'card_form_controller.dart';

class CardFormView extends StatelessWidget {
  const CardFormView({Key? key}) : super(key: key);

  static String name = '/card_form';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<CardFormController>();
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Text(
            'Card Form',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 20),
          CardFormField(
            controller: _.cardFormController,
          ),
          ElevatedButton(
            onPressed: _.saveCard,
            child: const Text('Pay'),
          ),
        ],
      )),
    );
  }
}
