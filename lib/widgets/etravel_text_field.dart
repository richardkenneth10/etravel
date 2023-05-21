import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';

class ETravelTextField extends StatelessWidget {
  const ETravelTextField({
    Key? key,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.clearText,
    this.keyboardType,
    this.autofocus = false,
    this.textStyle = const TextStyle(fontSize: 22),
    this.labelText,
    this.labelStyle,
    this.showSuffixIcon = false,
    this.prefixIcon,
    this.onTap,
    this.filled = true,
    this.hintText,
    this.hintStyle,
    this.height = 62,
    this.suffixIcon,
  }) : super(key: key);

  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? clearText;
  final TextInputType? keyboardType;
  final bool autofocus;
  final TextStyle textStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final bool showSuffixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool filled;
  final String? hintText;
  final TextStyle? hintStyle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        autofocus: autofocus,
        focusNode: focusNode,
        style: textStyle,
        cursorColor: AppColors.primary,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          labelText: labelText,
          labelStyle: TextStyle(color: AppColors.grey),
          floatingLabelStyle: labelStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          focusColor: Colors.white,
          fillColor: AppColors.inputField,
          filled: filled,
          suffixIcon: !showSuffixIcon
              ? null
              : suffixIcon ??
                  IconButton(
                    onPressed: clearText,
                    icon: Icon(
                      Icons.close,
                      color: AppColors.grey,
                    ),
                  ),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
