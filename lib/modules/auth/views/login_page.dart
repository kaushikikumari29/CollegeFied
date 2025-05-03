import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/utils/form_validators.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppPaddings.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.login, style: AppTextStyles.f24w600),
              SizedBox(height: AppSizes.s4),
              Text(AppStrings.loginSubTitle,
                  style: AppTextStyles.f14w400.copyWith(
                    color: AppColors.greyTextColor,
                  )),
              SizedBox(height: AppPaddings.xLarge),
              AppTextField(
                titleText: AppStrings.email,
                hintText: AppStrings.emailHint,
                controller: emailController,
                validator: FormValidators.emailValidator,
              ),
              AppTextField(
                titleText: AppStrings.password,
                hintText: AppStrings.passwordHint,
                controller: passwordController,
                isPassword: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: AppPaddings.medium),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                  child: Text(AppStrings.forgotPassword),
                ),
              ),
              SizedBox(height: AppPaddings.xLarge),
              Obx(() => AppButton(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      authController.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    text: AppStrings.login,
                    isLoading: authController.isLoading.value,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
