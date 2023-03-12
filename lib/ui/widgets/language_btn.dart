import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LanguageBtn extends StatelessWidget {
  String? text;
  String? textColor;
  String? bgColor;

  LanguageBtn({this.text, this.textColor, this.bgColor, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    print(textColor);
    return Container(
      width: mediaQuery.size.width,
      decoration: BoxDecoration(
          color: HexColor(bgColor!),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 3)),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 3),
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Text(
        text!,
        style: TextStyle(
            color: HexColor(textColor!),
            fontWeight: FontWeight.w600,
            fontSize: 16),
      ),
    );
  }
}
