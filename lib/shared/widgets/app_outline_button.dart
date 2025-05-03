import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isLoading;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final TextStyle? textStyle;

  const AppOutlineButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.isDisabled = false,
    this.isLoading = false,
    this.height = AppSizes.buttonSize,
    this.width,
    this.backgroundColor = const Color(0xFF2979FF), // attractive blue
    this.textColor = Colors.black,
    this.borderRadius = AppSizes.buttonRadius,
    this.elevation = 6,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool clickable = onTap != null && !isDisabled && !isLoading;

    return GestureDetector(
      onTap: clickable ? onTap : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.dividerColor)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: textColor,
                      size: 20,
                    ),
                  if (icon != null && text != null) const SizedBox(width: 8),
                  if (text != null)
                    Text(
                      text!,
                      style: textStyle ??
                          TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                ],
              ),
      ),
    );
  }
}
