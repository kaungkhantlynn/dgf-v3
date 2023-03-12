import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../models/vehicles_detail/vehicles_detail_model.dart';

class AlarmList extends StatelessWidget {
  VehiclesDetailModel? vehiclesDetailModel;
   AlarmList({Key? key,this.vehiclesDetailModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 40),
      height: size.height - 130,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 1,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        'Alarms',
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w700,
                            fontSize: 19),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                  height: size.height - 380,
                  child: ListView.builder(
                      itemCount: vehiclesDetailModel!.vehiclesDetailData!.alarms!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: HexColor( vehiclesDetailModel!.vehiclesDetailData!.alarms![index].color!)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.more_vert,color: Colors.white,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        vehiclesDetailModel!.vehiclesDetailData!.alarms![index].name!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                      const Padding(padding: EdgeInsets.all(5.5)),
                                      Text(
                                        vehiclesDetailModel!.vehiclesDetailData!.alarms![index].description!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        vehiclesDetailModel!.vehiclesDetailData!.alarms![index].startTime!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      const Padding(padding: EdgeInsets.all(1.5)),

                                    ],
                                  ),

                                ],
                              )
                            ],
                          ),
                        );
                      }))
            ],
          ),

        ],
      ),
    );
  }
}
