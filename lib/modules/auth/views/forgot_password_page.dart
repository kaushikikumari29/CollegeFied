import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/auth/controllers/auth_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: Padding(
        padding: EdgeInsets.all(AppPaddings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.forgotPassword, style: AppTextStyles.f24w600),
            SizedBox(height: AppSizes.s8),
            Text(AppStrings.forgotPasswordSubTitle,
                style: AppTextStyles.f14w400.copyWith(color: AppColors.greyTextColor)),
            SizedBox(height: AppPaddings.xLarge),
            AppTextField(
              titleText: AppStrings.email,
              hintText: AppStrings.emailHint,
              controller: emailController,
            ),
            SizedBox(height: AppPaddings.large),
            AppButton(
              text: AppStrings.sendOtp,
              onTap: () {
                controller.forgotPassword(emailController.text);
              }

              // => Get.toNamed(AppRoutes.otp),
            ),
          ],
        ),
      ),
    );
  }
}
