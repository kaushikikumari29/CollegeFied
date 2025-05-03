import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/utils/form_validators.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  SignUpPage({super.key}); // Add a constructor with optional key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: AppPaddings.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppPaddings.xxLarge + AppPaddings.large),
                    Text(AppStrings.register, style: AppTextStyles.f24w600),
                    SizedBox(height: AppSizes.s4),
                    Text(
                      AppStrings.registerSubTitle,
                      style: AppTextStyles.f14w400
                          .copyWith(color: AppColors.greyTextColor),
                    ),
                    SizedBox(height: AppPaddings.large),
                    AppTextField(
                      titleText: AppStrings.username,
                      hintText: AppStrings.usernameHint,
                      controller: _usernameController,
                      validator: FormValidators.usernameValidator,
                    ),
                    AppTextField(
                      titleText: AppStrings.email,
                      hintText: AppStrings.emailHint,
                      controller: _emailController,
                      validator: FormValidators.emailValidator,
                    ),
                    AppTextField(
                      titleText: AppStrings.password,
                      hintText: AppStrings.passwordHint,
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter password'
                          : null,
                    ),
                    AppTextField(
                      titleText: AppStrings.confirmPassword,
                      hintText: AppStrings.confirmPasswordHint,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      validator: (value) =>
                          FormValidators.confirmPasswordValidator(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    SizedBox(height: AppPaddings.medium),
                    Obx(() => AppButton(
                          onTap: _onRegister,
                          text: AppStrings.register,
                          isLoading: _authController.isLoading.value,
                        )),
                    SizedBox(height: AppPaddings.large),
                  ],
                ),
              ),
            ),
            Positioned(
                left: AppPaddings.pagePadding,
                top: AppPaddings.pagePadding,
                child: AppBackButton())
          ],
        ),
      ),
    );
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    _authController.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
      onSuccess: _clearFields,
    );
  }

  void _clearFields() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
