import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SettingCard extends StatelessWidget {
  String? title;
  String? color;
  IconData? iconData;
  String? info;
  bool? isInfoExit;

  SettingCard(
      {this.title, this.color, this.iconData, this.info, this.isInfoExit});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
        padding: const EdgeInsets.only(
          left: 25,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(bottom: 8, top: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor(color!),
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 26,
              ),
            ),
            Container(
              width: mediaQuery.size.width - 96,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title!,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Visibility(
                    visible: isInfoExit!,
                    replacement: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          size: 30,
                          color: Colors.grey.shade800,
                        )),
                    child: Container(
                      padding: const EdgeInsets.all(14.10),
                      child: Text(
                        info!,
                        style: TextStyle(
                            color: HexColor('#949397'),
                            fontSize: 19.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
