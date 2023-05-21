import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'save_payment_details_controller.dart';

class SavePaymentDetailsView extends StatelessWidget {
  const SavePaymentDetailsView({Key? key}) : super(key: key);

  static String name = '/save_payment_details';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<SavePaymentDetailsController>();
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
            child: const Text('Save'),
          ),
        ],
      )),
    );
  }
}
