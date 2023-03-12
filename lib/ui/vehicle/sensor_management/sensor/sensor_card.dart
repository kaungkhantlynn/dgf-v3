import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_cubit.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/edit_sensor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

class SensorArguments {
  final int id;
  SensorArguments(this.id);
}

class SensorCard extends StatelessWidget {
  int? id;
  DateTime? date;
  int? vehicleId;
  String? trackingNumber;
  String? installationLocation;
  String? type;
  String? model;
  String? description;
  String? status;
  SensorCard({required this.id, required this.date, required this.vehicleId, required this.trackingNumber,
    required this.installationLocation, required this.status,required this.type, required this.model, required this.description});
  // const SensorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sensorAction = BlocProvider.of<SensorActionCubit>(context);
    return Card(
        semanticContainer: true,
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                translate('vehicle_management_page.date'),
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontFamily: 'Kanit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(padding: EdgeInsets.all(1.3)),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "${date!.day}-${date!.month}-${date!.year}",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Kanit',
                    fontSize: 18),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //tracking number ,
                        translate('vehicle_management_page.tracking_number'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        trackingNumber!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //vehicle id
                        translate('vehicle_management_page.vehicle_id'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        vehicleId.toString(),
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //installation_location
                        translate('vehicle_management_page.installation_location'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        installationLocation!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8.5)),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //type
                        translate('vehicle_management_page.type'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        type!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //model
                        translate('vehicle_management_page.model'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        model!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //description
                        translate('vehicle_management_page.description'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        description!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('action'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(1.3)),
                      Wrap(
                        spacing: 1,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, EditSensor.route,
                                    arguments: SensorArguments(id!));
                              },
                              child: Icon(
                                Icons.edit,
                                color: HexColor('#0F8E70'),
                                size: 20,
                              )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        side: BorderSide(color: Colors.black,width: 2)
                                    ),
                                    title:  Text(translate('delete'),style: TextStyle(fontFamily: 'Inter',
                                        fontSize: 18,fontWeight: FontWeight.w600, color: Colors.black),),
                                    content: Container(
                                      child: Text(translate('sure_delete'),
                                          style: TextStyle(fontFamily: 'Inter',
                                              fontSize: 16, color: Colors.black)
                                        // textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Delete');
                                          sensorAction.delete(id!);
                                        },
                                        child:  Text(translate('delete'),
                                            style: TextStyle(fontFamily: 'Inter',
                                                fontSize: 16, color: Colors.red)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child:  Text(translate('cancel'),
                                            style: TextStyle(fontFamily: 'Inter',
                                                fontSize: 16, color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete_forever,
                                color: HexColor('#FF3232'),
                                size: 20,
                              ))
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('status'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(1.3)),
                      Container(
                        padding: EdgeInsets.all(5.5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.green.shade50, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5.5)),
                        ),
                        child: Text(
                          status!,
                          style: TextStyle(
                              color: Colors.green.shade700, fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.5),
            )
          ],
        ));
  }
}
