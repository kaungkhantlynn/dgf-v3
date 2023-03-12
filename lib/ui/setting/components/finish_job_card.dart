import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FinishJobCard extends StatelessWidget {
  String? title;
  String? info;

  FinishJobCard({
    this.title,
    this.info,
  });

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
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                title!,
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Wrap(
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(left: 14.10, top: 14.10, bottom: 14.10),
                    child: SizedBox(
                      width: mediaQuery.size.width / 2.5,
                      child: Text(
                        info!,
                        style: TextStyle(
                            height: 1.2,
                            color: HexColor('#949397'),
                            fontSize: 19.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Kanit'),
                        textAlign: TextAlign.right,
                      ),
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: Colors.grey.shade800,
                    )),
              ],
            )
          ],
        ));
  }
}
