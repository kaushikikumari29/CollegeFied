import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_strings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: Padding(
        padding: EdgeInsets.all(AppPaddings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.emailVerification, style: AppTextStyles.f24w600),
            SizedBox(height: AppSizes.s8),
            Text(AppStrings.emailVerificationSubTitle,
                style: AppTextStyles.f14w400.copyWith(color: AppColors.greyTextColor)),
            SizedBox(height: AppPaddings.xLarge),
            AppButton(
              text: AppStrings.resendEmail,
              onTap: () {},
            ),
            SizedBox(height: AppPaddings.medium),
            AppButton(
              text: AppStrings.continueText,
              onTap: () => Get.toNamed(AppRoutes.otp),
            ),
          ],
        ),
      ),
    );
  }
}
