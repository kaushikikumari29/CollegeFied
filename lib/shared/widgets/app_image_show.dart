import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class AppImageShow extends StatelessWidget {
  final String src;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isAsset;
  final bool isLottie;
  final bool isSvg;

  const AppImageShow({
    super.key,
    required this.src,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.isAsset = false,
    this.isLottie = false,
    this.isSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (isLottie) {
        return isAsset
            ? Lottie.asset(src, height: height, width: width, fit: fit)
            : Lottie.network(src, height: height, width: width, fit: fit);
      }

      if (isSvg) {
        return isAsset
            ? SvgPicture.asset(src, height: height, width: width, fit: fit)
            : SvgPicture.network(src, height: height, width: width, fit: fit);
      }

      return isAsset
          ? Image.asset(src, height: height, width: width, fit: fit)
          : Image.network(
        src,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: height,
            width: width,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) => SizedBox(
          height: height,
          width: width,
          child: const Center(child: Icon(Icons.broken_image)),
        ),
      );
    } catch (e) {
      return SizedBox(
        height: height,
        width: width,
        child: const Center(child: Icon(Icons.error)),
      );
    }
  }
}
