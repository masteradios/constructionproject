import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hiten/WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageTransitionsTheme pageTransitionsTheme = PageTransitionsTheme();

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: MediaQuery.of(context).size.height / 2,
      centered: true,
      splashTransition: SplashTransition.fadeTransition,
      screenFunction: () async {
        return WelcomeScreen();
      },
      splash: SizedBox(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
                child: Image.asset('assets/logo.png')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
                strokeWidth: 6,
              ),
            )
          ],
        ),
      ),
    );
  }
}
