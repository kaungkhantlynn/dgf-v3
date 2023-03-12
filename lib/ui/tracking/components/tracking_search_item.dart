import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TrackingSearchItem extends StatelessWidget {
  String? color;
  String? title;
  String? titleColor;

  TrackingSearchItem({this.color, this.title, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 20, bottom: 20),
      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(color!),
      ),
      child: Text(
        title!,
        style: TextStyle(
            color: HexColor(titleColor!),
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
