import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactCard extends StatelessWidget {
  String? color;
  String? title;
  IconData iconData;
  ContactCard({
    Key? key,
    required this.color,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HexColor(color!),
      margin: const EdgeInsets.all(7.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: Text(
              title!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 25, bottom: 25),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 70,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
