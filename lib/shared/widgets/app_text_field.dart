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

  static const Color borderColor = Color(0xFFE0E0E0);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSizes.s8),
        Text(
          titleText,
          style: AppTextStyles.f14w600
              .copyWith(color: AppColors.darkGreyTextColor),
        ),
        SizedBox(height: AppSizes.s8),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: AppTextStyles.f16w600,
          cursorHeight: AppSizes.textFieldCursorHeight,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textFieldBgColor,
            hintText: hintText,
            hintStyle:
                AppTextStyles.f14w400.copyWith(color: AppColors.hintTextColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            errorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedErrorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            disabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: const BorderSide(color: borderColor),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        const SizedBox(height: AppPaddings.medium),
      ],
    );
  }
}
