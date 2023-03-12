import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';


class VehicleCard extends StatefulWidget {
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
  double? lat;
  double? lng;
  String? duration;
  String? updatedAt;

   VehicleCard({Key? key,
    this.routeName,
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
    this.fuelUnit,
   this.lat,
   this.lng,
   this.duration,
   this.updatedAt}) : super(key: key);

  @override
  _VehicleCardState createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {

  Dio dio =Dio();

  String? location;

  String dateFormatter({String? date}){
    DateTime dt = DateTime.parse(date!);
    String formattedDate = DateFormat('HH:mm:ss').format(dt);
    return formattedDate;
  }

  // _getHttp(String lon, String lat) async {
  //   try {
  //     var response = await Dio().get('http://api.longdo.com/map/services/addresses',
  //         queryParameters: {'locale': 'en','lon[]':lon ,'lat[]': lat,'key':'078388adf4e2609e085f0b8225c6d325'});
  //
  //     if (response.data[0] != null) {
  //       print("LONGDO_RESPONSE_NOTNULL");
  //       print(response.data[0]);
  //       setState(() {
  //         location = (response.data[0].province);
  //       });
  //     }
  //     return "UUUUEEE";
  //   } catch (e) {
  //     print(e);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {

   // _getHttp(widget.lng.toString(), widget.lat.toString());
   print("LOCATION $location");
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
                            circleCar('#C1C4C7', '#D3D5D6', widget.iconUrl!),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.location_on),
                                    BlocBuilder<LongdoLocationCubit,LongdoLocationState>(
                                        builder: (context,state){

                                          if (state is LongdoLocationCompleted) {
                                            // var province = state.longdoLocation![0].province!
                                            return SizedBox(
                                              width: 150,
                                              child: Text(
                                                // 'N/A',
                                                ' ${state.longdoLocation![0].province!} ${state.longdoLocation![0].subdistrict!} ${state.longdoLocation![0].district!}' ,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17),
                                              ),
                                            );
                                          }
                                          return const Text('--');
                                        })
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(1.5)),
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.local_taxi),
                                    SizedBox(
                                      width: 150,
                                      child:  Text(
                                        widget.carNumber!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                    )
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(1.5)),
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.credit_card),
                                    Container(
                                      width: 150,
                                      child:  Text(
                                        widget.driverName!.isNotEmpty ? widget.driverName! : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                    )
                                  ],
                                ),
                                // Wrap(
                                //   spacing: 5.5,
                                //   children: [
                                //     const Icon(Icons.access_time),
                                //     Text(
                                //       widget.duration!,
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 17),
                                //     ),
                                //   ],
                                // ),
                                Wrap(
                                  spacing: 5.5,
                                  children: [
                                    const Icon(Icons.access_time),
                                    Text(
                                      widget.updatedAt!,
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
                      widget.speed!,
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
                    Text(
                     widget.time!,
                      style: const TextStyle(
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
                      widget.temperature! !="null" ? widget.temperature!: '-',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.temperatureUnit!,
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
                      widget.fuel!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.fuelUnit!,
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


