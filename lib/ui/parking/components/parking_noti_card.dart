import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ParkingNotiCard extends StatelessWidget {
   String? color;
  String notiTitle;
  String carNumber;
  String status;
  String datetime;

  ParkingNotiCard({
    Key? key,
     this.color,
    required this.notiTitle,
    required this.carNumber,
    required this.status,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 10, top: 25, bottom: 28),
      margin: const EdgeInsets.only(top: 22, left: 16, right: 16),
      decoration: BoxDecoration(
        color: HexColor(color!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notiTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              const Padding(padding: EdgeInsets.all(10.2)),
              Text(
                '$carNumber $status',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const Padding(padding: EdgeInsets.all(4.2)),
              Text(
                datetime,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),

          //menu
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
