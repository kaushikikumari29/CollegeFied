import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final currentPassword = TextEditingController();

  final newPasswordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: Padding(
          padding: EdgeInsets.all(AppPaddings.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.resetPassword, style: AppTextStyles.f24w600),
              SizedBox(height: AppSizes.s8),
              AppTextField(
                titleText: AppStrings.currentPassoword,
                hintText: AppStrings.passwordHint,
                controller: currentPassword,
                isPassword: true,
              ),
              AppTextField(
                titleText: AppStrings.password,
                hintText: AppStrings.passwordHint,
                controller: newPasswordController,
                isPassword: true,
              ),
              AppTextField(
                titleText: AppStrings.confirmPassword,
                hintText: AppStrings.passwordHint,
                controller: confirmPasswordController,
                isPassword: false,
              ),
              SizedBox(height: AppPaddings.large),
              Obx(() => AppButton(
                    text: AppStrings.resetPassword,
                    onTap: () {
                      if (currentPassword.text.isEmpty) {
                        Get.snackbar('Error', 'Please enter current password');
                        return;
                      }
                      if (newPasswordController.text.isEmpty) {
                        Get.snackbar('Error', 'Please enter new password');
                        return;
                      }
                      if (confirmPasswordController.text.isEmpty) {
                        Get.snackbar('Error', 'Please enter confirm password');
                        return;
                      }
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        Get.snackbar('Error', 'Passwords do not match');
                        return;
                      }
                      controller.resetPassword(
                          currentPassword.text,
                          newPasswordController.text,
                          confirmPasswordController.text);
                    },
                    isLoading: controller.isLoading.value ?? false,
                  )),
            ],
          )),
    );
  }
}
