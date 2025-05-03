import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String titleText;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final int maxLines;
  final Widget? suffixIcon;

  static const Color borderColor = Color(0xFFE0E0E0); // Light border

  const AppTextField({
    super.key,
    required this.controller,
    required this.titleText,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isEnabled = true,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              style: AppTextStyles.f14w600
                  .copyWith(color: AppColors.darkGreyTextColor),
            ),
            SizedBox(height: AppSizes.s8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                obscureText: isPassword,
                keyboardType: keyboardType,
                maxLines: maxLines,
                onChanged: field.didChange,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTextStyles.f12w600
                        .copyWith(color: AppColors.greyTextColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 6.0)),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 6.0),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            const SizedBox(height: AppPaddings.medium),
          ],
        );
      },
    );
  }
}
