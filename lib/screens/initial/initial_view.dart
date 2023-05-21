import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';

class InitialView extends StatelessWidget {
  const InitialView({Key? key}) : super(key: key);

  static String name = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}
