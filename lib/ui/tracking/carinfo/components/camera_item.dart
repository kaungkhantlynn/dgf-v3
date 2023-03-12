import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CameraItem extends StatelessWidget {
  String? cameraName;
  String? status;
  String? textColor;
  String? bgColor;

  CameraItem(
      {Key? key, this.cameraName, this.status, this.textColor, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width,
      decoration: BoxDecoration(
          color: HexColor(bgColor!),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 3)),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 3),
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5.5)),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cameraName!,
                style: TextStyle(
                    color: HexColor(textColor!),
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
              const Padding(padding: EdgeInsets.all(4.5)),
              Text(
                status!.toUpperCase(),
                style: TextStyle(
                    color: HexColor(textColor!),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
