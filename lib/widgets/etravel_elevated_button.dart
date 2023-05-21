import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ETravelElevatedButton extends StatelessWidget {
  const ETravelElevatedButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor,
      this.textColor})
      : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: Get.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? AppColors.primary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
