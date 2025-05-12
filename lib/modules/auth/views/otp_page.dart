import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/auth/controllers/auth_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpPage extends StatelessWidget {
  final otpController = TextEditingController();
  final authController = Get.find<AuthController>();

  late final String email;
  late final String password;

  OtpPage({Key? key}) : super(key: key) {
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    password = args['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: const AppBackButton(),
      ),
      body:   Padding(
        padding: EdgeInsets.all(AppPaddings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.otpVerification,
                style: AppTextStyles.f24w600),
            SizedBox(height: AppSizes.s8),
            Text(AppStrings.otpSentToEmail,
                style: AppTextStyles.f14w400
                    .copyWith(color: AppColors.greyTextColor)),
            SizedBox(height: AppPaddings.xLarge),
            AppTextField(
              titleText: AppStrings.enterOtp,
              hintText: '',
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppPaddings.large),
            Obx(() => AppButton(
              text: AppStrings.verify,
              isLoading: authController.isLoading.value,
              onTap: () {
                if (otpController.text.trim().isEmpty) {
                  Get.snackbar("Error", "OTP cannot be empty");
                  return;
                }

                authController.verifyOtp(
                  email,
                  password,
                  otpController.text.trim(),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
