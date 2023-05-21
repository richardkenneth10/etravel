import 'package:etravel/config/app_colors.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:etravel/widgets/etravel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'phone_controller.dart';

class PhoneView extends StatelessWidget {
  const PhoneView({Key? key}) : super(key: key);

  static String name = '/phone';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<PhoneController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Enter your number',
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Column(
          children: [
            Obx(
              () => ETravelTextField(
                onChanged: _.onPhoneChanged,
                controller: _.textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                focusNode: _.focusNode,
                filled: false,
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 70,
                  child: InkWell(
                    onTap: () => _.openCountries(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                        ),
                        Obx(
                          () => Text(
                            _.countryCode,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                showSuffixIcon: _.phone.isNotEmpty,
                clearText: _.clearText,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: Get.width / 2.5,
                child: Text(
                  'We will send an SMS code to verify your number',
                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => ETravelElevatedButton(
                text: 'Continue',
                onPressed: _.phone.isEmpty ? null : _.sendOTP,
                backgroundColor: _.phone.isEmpty ? AppColors.inputField : null,
                textColor: _.phone.isEmpty ? AppColors.grey : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
