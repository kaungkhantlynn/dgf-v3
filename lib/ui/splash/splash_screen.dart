import 'dart:ui';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // checkNetwork(context);
    // startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return splashLoading();
  }

  Scaffold splashLoading() {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset('assets/original_bg.png').image,
                    fit: BoxFit.cover)),
            child: const FrostedGlassBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )));
  }
}

class FrostedGlassBox extends StatelessWidget {
  final Widget child;

  const FrostedGlassBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        child: Stack(
          children: [
            BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 60.0,
                  sigmaY: 60.0,
                ),
                child: Container(color: Colors.grey.shade100.withOpacity(0.6))),
            Container(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
