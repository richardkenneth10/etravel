import 'dart:developer';

import 'package:etravel/config/app_colors.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:etravel/widgets/etravel_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'name_controller.dart';

class NameView extends StatelessWidget {
  const NameView({Key? key}) : super(key: key);

  static String name = '/name';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<NameController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'What\s your name?',
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
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ETravelTextField(
                      onChanged: _.onFirstNameChanged,
                      controller: _.firstNameController,
                      keyboardType: TextInputType.emailAddress,
                      filled: false,
                      autofocus: true,
                      focusNode: _.firstFocusNode,
                      labelText: 'First name',
                      labelStyle: TextStyle(color: AppColors.primary),
                      clearText: _.clearFirstName,
                      showSuffixIcon:
                          _.firstName.isNotEmpty && _.firstFocusNode.hasFocus,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Obx(
                    () => ETravelTextField(
                      onChanged: _.onLastNameChanged,
                      controller: _.lastNameController,
                      keyboardType: TextInputType.emailAddress,
                      filled: false,
                      // autofocus: true,
                      focusNode: _.lastFocusNode,
                      labelText: 'Last name',
                      labelStyle: TextStyle(color: AppColors.primary),
                      clearText: _.clearLastName,
                      showSuffixIcon:
                          _.lastName.isNotEmpty && _.lastFocusNode.hasFocus,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Driver will confirm picking up the right person by your name',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => ETravelElevatedButton(
                text: 'Done',
                onPressed: _.emptyFields ? null : _.saveNames,
                backgroundColor: _.emptyFields ? AppColors.inputField : null,
                textColor: _.emptyFields ? AppColors.grey : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
