import 'package:flutter/material.dart';

class ShowSnackBar {
  ShowSnackBar._();

  static showWithScaffold(GlobalKey<ScaffoldState> scaffoldKey,
      BuildContext context, String message,
      {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(message),
    ));
  }

  static show(BuildContext context, String message,
      {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }
}
