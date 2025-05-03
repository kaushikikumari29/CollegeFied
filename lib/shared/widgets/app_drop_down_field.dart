import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';

class AppDropdownField extends StatelessWidget {
  final String titleText;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const AppDropdownField({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText, style: AppTextStyles.f14w500),
        SizedBox(height: AppSizes.s8),
        DropdownButtonFormField<String>(
          value: value?.isEmpty ?? true ? null : value,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textFieldBgColor,
            hintText: hintText,
            hintStyle: AppTextStyles.f12w500.copyWith(
              color: AppColors.greyTextColor,
              fontSize: 12,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: BorderSide(color: Colors.red),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyles.f14w600.copyWith(
                        color: AppColors.darkGreyTextColor,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
