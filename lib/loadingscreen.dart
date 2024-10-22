import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  final double height;
  const LoadingScreen({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Lottie.asset('assets/loading.json', height: height),
      ),
    );
  }
}
