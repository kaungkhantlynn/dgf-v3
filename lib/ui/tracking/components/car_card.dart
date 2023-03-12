import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class CarCard extends StatelessWidget {
  String? routeName;
  String? carNumber;
  String? driverName;
  String? speedUnit;
  String? speed;
  String? time;
  String? centigrade;
  String? innerColor;
  String? outterColor;
  String? iconUrl;
  String? temperature;
  String? temperatureUnit;
  String? fuel;
  String? fuelUnit;

  CarCard(
      {this.routeName,
      this.carNumber,
      this.driverName,
      this.speedUnit,
      this.speed,
      this.time,
      this.centigrade,
      this.innerColor,
      this.outterColor,
      this.iconUrl,
      this.temperature,
      this.temperatureUnit,
      this.fuel,
      this.fuelUnit});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 360,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 15.5,
                          children: [
                            circleCar('#C1C4C7', '#D3D5D6', iconUrl!),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.location_on),
                                    Text(
                                      routeName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(1.5)),
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.local_taxi),
                                    Text(
                                      carNumber!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(1.5)),
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.credit_card),
                                    Text(
                                      driverName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Icon(Icons.more_vert_outlined),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(5.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      speed!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'km / hr',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '3:45:12',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      temperature!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      temperatureUnit!,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      fuel!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      fuelUnit!,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
              ],
            )
          ],
        ));
  }

  Container circleCar(String innerColor, String outterColor, String iconUrl) {
    return Container(
      decoration:
          BoxDecoration(color: HexColor(outterColor), shape: BoxShape.circle),
      padding: const EdgeInsets.all(9.8),
      child: Container(
          decoration: BoxDecoration(
              color: HexColor(innerColor), shape: BoxShape.circle),
          padding: const EdgeInsets.all(20.2),
          child: SvgPicture.string(iconUrl, width: 50, height: 50)),
    );
  }
}
