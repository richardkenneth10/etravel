import 'package:etravel/config/app_colors.dart';
import 'package:etravel/config/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'payment_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key? key}) : super(key: key);

  static String name = '/payment';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<PaymentController>();

    final cardTypeToIconMap = {
      'visa': Assets.icVisaCard,
      'master': Assets.icMasterCard,
    };

    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: Get.back,
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ETravel Balance',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₦0',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      SizedBox(height: 12),
                      Text(
                          "ETravel balance is not available with this payment method")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.help_outline_rounded,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 25),
                          Text("What is ETravel balance?")
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.lock_clock,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 25),
                          Text("See transactions")
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => Column(
                children: [
                  const Text(
                    'Payment methods',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ..._.savedCards
                      .map(
                        (element) => GestureDetector(
                          onTap: () => _.onCardTap(element.id),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                        cardTypeToIconMap[element.cardBrand] ??
                                            Assets.icFacebook,
                                      ))),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('.... ${element.last4}'),
                                    const Spacer(),
                                    const Icon(
                                      Icons.radio_button_unchecked,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: const [
                            Icon(Icons.money),
                            SizedBox(width: 12),
                            Text('Cash'),
                            Spacer(),
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _.goToCardSavingScreen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: const [
                          Icon(Icons.card_travel),
                          SizedBox(width: 12),
                          Text('Add debit/credit card'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Row(
              children: const [
                Icon(
                  Icons.work_outline_rounded,
                  color: Colors.grey,
                ),
                SizedBox(width: 20),
                Text('Set up work profile')
              ],
            ),
          )
        ],
      ),
    );
  }
}
