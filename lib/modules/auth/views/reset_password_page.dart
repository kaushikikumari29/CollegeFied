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

class ResetPasswordPage extends StatelessWidget {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
              titleText: AppStrings.password,
              hintText: AppStrings.passwordHint,
              controller: newPasswordController,
              isPassword: true,
            ),
            SizedBox(height: AppPaddings.medium),
            AppTextField(
              titleText: AppStrings.confirmPassword,
              hintText: AppStrings.passwordHint,
              controller: confirmPasswordController,
              isPassword: true,
            ),
            SizedBox(height: AppPaddings.large),
            AppButton(
              text: AppStrings.resetPassword,
              onTap: () => Get.toNamed(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
