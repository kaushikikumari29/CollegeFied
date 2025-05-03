import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingState extends StatelessWidget {
  final String lottieAsset;
  final double? topPadding;

  const LoadingState({
    Key? key,
    required this.lottieAsset,
    this.topPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget lottie = Lottie.asset(
      lottieAsset,
      width: 65,
      height: 65,
      fit: BoxFit.contain,
    );

    return Center(
      child: topPadding != null
          ? Padding(
              padding: EdgeInsets.only(top: topPadding!),
              child: lottie,
            )
          : lottie,
    );
  }
}
