import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/list/vehicle_bloc.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/action/vehicle_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/action/vehicle_type_action_state.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/list/vehicle_type_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/add_vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/add_vehicle_type.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class VehicleType extends StatefulWidget {
  static const String route = '/vehicle_type';
  const VehicleType({Key? key}) : super(key: key);

  @override
  _VehicleTypeState createState() => _VehicleTypeState();
}

class _VehicleTypeState extends State<VehicleType> {
  VehicleTypeBloc vehicleTypeBloc=VehicleTypeBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    vehicleTypeBloc.add(GetVehicleType());
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloading');

    _receivePort.listen((message) {
      setState(() {
        print(message[2]);
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    final action = BlocProvider.of<VehicleTypeActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.vehicle_type'),
        ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(8.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade700,
                      padding: const EdgeInsets.all(15.5),
                      textStyle: const TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      action.export();
                    },
                    child: Wrap(
                      spacing: 1,
                      children: [
                        Icon(
                          Icons.file_download,
                          color: Colors.white,
                          size: 17,
                        ),
                        Text(
                          translate('export'),
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )
                      ],
                    )),
                Padding(padding: EdgeInsets.all(2.2)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade700,
                      padding: const EdgeInsets.all(15.5),
                      textStyle: const TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AddVehicleType.route);
                    },
                    child: Wrap(
                      spacing: 1,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 17,
                        ),
                        Text(
                          translate('add'),
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )
                      ],
                    )),
                Padding(padding: EdgeInsets.all(8.0)),
              ],
            ),
            BlocBuilder<VehicleTypeBloc,VehicleTypeState>(
              bloc: vehicleTypeBloc,
              builder: (context,state){
                if(state is VehicleTypeLoaded){
                  return
                    BlocListener<VehicleTypeActionCubit,VehicleTypeActionState>(
                        listener: (context, state){
                          if (state is VehicleTypeActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is VehicleTypeActionFinished) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(translate('successful'))),
                            );
                            Future.delayed(Duration(seconds: 1), () async {
                              Navigator.pop(context,true);
                            });
                          }
                        },
                        child:
                        Expanded(
                          child:
                          ListView.builder(
                              itemCount: state.vehicleTypeData!.length,
                              itemBuilder: (context,index){
                                return VehicleTypeCard(
                                  id:state.vehicleTypeData![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.vehicleTypeData![index].createdAt!),
                                  max_speed: state.vehicleTypeData![index].maximumSpeed,
                                  alarm_interval: state.vehicleTypeData![index].alarmInterval,
                                  type: state.vehicleTypeData![index].type,
                                  icon_color: state.vehicleTypeData![index].iconColor,
                                );
                              }
                          ),
                        )
                    );
                }
                return Center(
                  child: CircularProgressIndicator(),);
              },
            ),
          ],
        ));
  }
}
