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

class OtpPage extends StatefulWidget {
  late final String email;
  late final bool? fromResetPassword;
  // late final String password;

  OtpPage({Key? key}) : super(key: key) {
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    fromResetPassword = args['fromResetPassword'] ?? false;
    // password = args['password'];
  }

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();
  final passController = TextEditingController();
  final cPassController = TextEditingController();

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppPaddings.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.otpVerification, style: AppTextStyles.f24w600),
              SizedBox(height: AppSizes.s8),
              Text(AppStrings.otpSentToEmail,
                  style: AppTextStyles.f14w400
                      .copyWith(color: AppColors.greyTextColor)),
              SizedBox(height: AppPaddings.xLarge),
              AppTextField(
                titleText: AppStrings.enterOtp,
                hintText: AppStrings.enterOtp,
                controller: otpController,
                keyboardType: TextInputType.number,
              ),
              // SizedBox(height: AppPaddings.medium),
              AppTextField(
                titleText: AppStrings.password,
                hintText: AppStrings.passwordHint,
                controller: passController,
                isPassword: true,
              ),
              AppTextField(
                titleText: AppStrings.confirmPassword,
                hintText: AppStrings.passwordHint,
                controller: cPassController,
                isPassword: false,
              ),
              // SizedBox(height: AppPaddings.large),
              SizedBox(height: AppPaddings.large),
              Obx(() => AppButton(
                    text: AppStrings.verify,
                    isLoading: authController.isLoading.value,
                    onTap: () {
                      if (otpController.text.trim().isEmpty) {
                        Get.snackbar("Error", "OTP cannot be empty");
                        return;
                      }
                      if (widget.fromResetPassword == true) {
                        if (passController.text.trim().isEmpty) {
                          Get.snackbar("Error", "Reset Your password");
                          return;
                        }
                        if (cPassController.text.trim().isEmpty) {
                          Get.snackbar("Error", "Confirm Your password");
                          return;
                        }

                        if (passController.text.trim() !=
                            cPassController.text.trim()) {
                          Get.snackbar("Error", "Passwords do not match");
                          return;
                        }
                      }

                      if (widget.fromResetPassword == true) {
                        authController.resetPassword(
                          widget.email,
                          passController.text.trim(),
                          cPassController.text.trim(),
                          otpController.text.trim(),
                        );
                      } else {
                        authController.verifyOtp(
                          widget.email,
                          otpController.text.trim(),
                        );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
