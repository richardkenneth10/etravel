import 'package:etravel/config/app_colors.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setup_profile_controller.dart';

class SetupProfileView extends StatelessWidget {
  const SetupProfileView({Key? key}) : super(key: key);

  static String name = '/setup_profile';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<SetupProfileController>();

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            children: [
              const Text(
                'Set up your profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              ETravelElevatedButton(
                text: 'Continue with email',
                onPressed: _.goToEmailScreen,
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
                  onPressed: _.continueWithGoogle,
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
                    children: const [
                      Center(
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
                        child: Icon(Icons.grid_on_outlined),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: _.continueWithFacebook,
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
                    children: const [
                      Center(
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
                        child:
                            Icon(Icons.facebook_outlined, color: Colors.blue),
                      )
                    ],
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
