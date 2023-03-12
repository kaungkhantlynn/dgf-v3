import 'package:flutter/material.dart';

class VehicleMenu extends StatelessWidget {
  String? title;

  VehicleMenu({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
        width: mediaQuery.size.width,
        padding: const EdgeInsets.only(left: 20, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Container(
            //   width: 44,
            //   height: 44,
            //   margin: const EdgeInsets.only(bottom: 8, top: 7),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: HexColor(color!),
            //   ),
            //   child: Icon(
            //     iconData,
            //     color: Colors.white,
            //     size: 26,
            //   ),
            // ),
            Container(
              width: mediaQuery.size.width - 21,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
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
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        size: 30,
                        color: Colors.grey.shade800,
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
