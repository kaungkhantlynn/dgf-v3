import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/action/vehicle_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/action/vehicle_action_state.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/list/vehicle_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/add_vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/vehicle_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class Vehicle extends StatefulWidget {
  static const String route = '/vehicle';
  const Vehicle({Key? key}) : super(key: key);

  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  VehicleBloc vehicleBloc=VehicleBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloadingvehicle');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    vehicleBloc.add(GetVehicle());
      IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloadingvehicle');

      _receivePort.listen((message) {

      });
      FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    final action = BlocProvider.of<VehicleActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.vehicle'),
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
                      Navigator.pushNamed(context, AddVehicle.route);
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
            BlocBuilder<VehicleBloc,VehicleState>(
              bloc: vehicleBloc,
              builder: (context,state){
                if(state is VehicleLoaded){
                  return
                    BlocListener<VehicleActionCubit,VehicleActionState>(
                        listener: (context, state){
                          if (state is VehicleActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is VehicleActionFinished) {
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
                              itemCount: state.vehicleData!.length,
                              itemBuilder: (context,index){
                                return VehicleCard(
                                  id: state.vehicleData![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.vehicleData![index].createdAt!),
                                  name: state.vehicleData![index].name,
                                  chassisNumber: state.vehicleData![index].chassisNumber,
                                  license: state.vehicleData![index].license,
                                  province: state.vehicleData![index].province,
                                  color: state.vehicleData![index].color,
                                  brand: state.vehicleData![index].brand,
                                  model: state.vehicleData![index].model,
                                  status: state.vehicleData![index].status,
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
