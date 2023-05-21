import 'package:etravel/config/app_colors.dart';
import 'package:etravel/config/assets.dart';
import 'package:etravel/helpers/classes.dart';
import 'package:etravel/screens/auth/auth_controller.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:etravel/widgets/etravel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  static String name = '/auth';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<AuthController>();

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                children: [
                  const Text(
                    'Enter your number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ETravelTextField(
                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: _.goToPhoneScreen,
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
                  ),

                  const SizedBox(height: 10),
                  ETravelElevatedButton(
                    text: 'Sign in',
                    onPressed: _.goToPhoneScreen,
                  ),
                  const SizedBox(height: 20),
                  //or divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _.signInWithGoogle,
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(color: AppColors.outlineButton),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              Assets.icGoogle,
                              height: 24,
                              width: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _.signInWithFacebook,
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(color: AppColors.outlineButton),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Text(
                              'Sign in with Facebook',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              Assets.icFacebook,
                              height: 24,
                              width: 24,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text.rich(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                const TextSpan(
                  children: [
                    TextSpan(text: 'If you are creating a new account, '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' will apply'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
