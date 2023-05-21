import 'package:etravel/config/app_colors.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:etravel/widgets/etravel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'email_controller.dart';

class EmailView extends StatelessWidget {
  const EmailView({Key? key}) : super(key: key);

  static String name = '/email';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<EmailController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Enter your email',
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
                onChanged: _.onEmailChanged,
                controller: _.textController,
                keyboardType: TextInputType.emailAddress,
                filled: false,
                autofocus: true,
                focusNode: _.focusNode,
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.primary),
                clearText: _.clearText,
                showSuffixIcon: _.email.isNotEmpty,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'We\'ll send you your ride receipts',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => ETravelElevatedButton(
                text: 'Continue',
                onPressed: _.email.isEmpty ? null : _.saveEmail,
                backgroundColor: _.email.isEmpty ? AppColors.inputField : null,
                textColor: _.email.isEmpty ? AppColors.grey : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
