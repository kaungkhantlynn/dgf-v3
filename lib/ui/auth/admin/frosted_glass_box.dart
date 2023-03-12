import 'dart:ui';

import 'package:flutter/material.dart';

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
