import 'package:flutter/material.dart';
import 'package:how_to_cook/common/animations.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size = 200.0});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Animations.getRandomAnimation,
        width: size,
        height: size,
      ),
    );
  }
}
