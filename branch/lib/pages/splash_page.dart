import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:branch/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/logo.png',
      animationDuration: const Duration(seconds: 1),
      duration: 1200,
      splashIconSize: 200,
      centered: true,
      backgroundColor: const Color.fromRGBO(54, 54, 51, 1),
      nextScreen: const MyHomePage(),
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
