import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'otp_controller.dart';

class OTPView extends StatelessWidget {
  const OTPView({Key? key}) : super(key: key);

  static String name = '/otp';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<OTPController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Enter code',
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
          vertical: 20,
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'An SMS code was sent to',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _.phone(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: _.editPhonenumber,
                child: Text(
                  'Edit phone number',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                appContext: context,
                length: 6,
                onChanged: (value) {},
                onCompleted: _.verifyCode,
                autoFocus: true,
                pinTheme: PinTheme(
                  inactiveFillColor: AppColors.grey,
                  borderWidth: 0,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeColor: AppColors.grey,
                  activeFillColor: AppColors.grey,
                  inactiveColor: AppColors.grey,
                  selectedFillColor: Colors.white,
                  selectedColor: AppColors.primary,
                ),
                showCursor: false,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                // backgroundColor: Colors.white,
                beforeTextPaste: (text) => true,
              ),
              const Spacer(),
              !_.isTimeout()
                  ? Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Resend code in ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '${_.count()}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: _.resendCode,
                      child: Text(
                        'Resend code',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
