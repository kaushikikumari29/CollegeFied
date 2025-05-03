import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyDataState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String lottieAsset;

  const EmptyDataState({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.lottieAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            lottieAsset,
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          Text(
            title,
            style: AppTextStyles.f18w600,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: AppTextStyles.f14w400.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
