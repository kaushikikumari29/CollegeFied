import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppPaddings.pagePadding, AppPaddings.small, 0.0, 0.0),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        onTap: () {
          Get.back();
        },
        child: Container(
          height: AppSizes.backButtonSize,
          width: AppSizes.backButtonSize,
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.dividerColor, width: 0.3),
            borderRadius: BorderRadius.circular(AppSizes.backButtonRadius),
          ),
          child: Center(
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
      ),
    );
  }
}
