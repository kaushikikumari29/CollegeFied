import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/shared/utils/app_images.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_image_show.dart';
import 'package:collegefied/shared/widgets/app_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPaddings.pagePadding),
          child: Column(
            children: [
              Expanded(
                child: AppImageShow(
                  src: AppImages.welcomeLottie,
                  isLottie: true,
                  isAsset: true,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.ac_unit),
                      SizedBox(width: AppPaddings.small),
                      Text(AppStrings.appName, style: AppTextStyles.f18w600),
                    ],
                  ),
                  SizedBox(height: AppPaddings.pagePadding),
                  Text(AppStrings.appTagLine, style: AppTextStyles.f20w500),
                  const SizedBox(height: 8),
                  Text(AppStrings.appDescription,
                      style:
                          AppTextStyles.f10w400.copyWith(color: Colors.grey)),
                  const SizedBox(height: 16),
                  AppButton(
                    text: AppStrings.login,
                    onTap: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    isLoading: false,
                    isDisabled: false,
                    height: AppSizes.buttonSize,
                  ),
                  const SizedBox(height: 12),
                  AppOutlineButton(
                    text: "Register",
                    onTap: () {
                      Get.toNamed(AppRoutes.signup);
                    },
                    isLoading: false,
                    isDisabled: false,
                    height: AppSizes.buttonSize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
