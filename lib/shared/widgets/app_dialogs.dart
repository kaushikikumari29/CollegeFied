import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  static void showLogoutDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context: context,
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        confirmColor: Colors.red,
        onConfirm: onConfirm,
      ),
    );
  }

  static void showDeleteProductDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    String productName = 'this product',
  }) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context: context,
        title: 'Delete Product',
        message: 'Are you sure you want to delete $productName?',
        confirmText: 'Delete',
        confirmColor: Colors.redAccent,
        onConfirm: onConfirm,
      ),
    );
  }

  static Widget _buildDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    required Color confirmColor,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.small,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppOutlineButton(
                  onTap: () => Navigator.of(context).pop(),
                  text: "Cancel",
                ),
              ),
              SizedBox(
                width: AppPaddings.small,
              ),
              Expanded(
                child: AppButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  text: confirmText,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
