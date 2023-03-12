import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_state.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/list/sensor_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/add_sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/sensor_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class Sensor extends StatefulWidget {
  static const String route = '/sensor';
  const Sensor({Key? key}) : super(key: key);

  @override
  _SensorState createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  SensorBloc sensorBloc=SensorBloc(getIt<MngApi>());

  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    sensorBloc.add(GetSensor());

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
    final action = BlocProvider.of<SensorActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.sensor'),
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
                      Navigator.pushNamed(context, AddSensor.route);
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
            BlocBuilder<SensorBloc,SensorState>(
              bloc: sensorBloc,
              builder: (context,state){
                if(state is SensorLoaded){
                  return
                    BlocListener<SensorActionCubit,SensorActionState>(
                        listener: (context, state){
                          if (state is SensorActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is SensorActionFinished) {
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
                              itemCount: state.sensorData!.length,
                              itemBuilder: (context,index){
                                return  SensorCard(
                                  id:state.sensorData![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.sensorData![index].createdAt!),
                                  vehicleId: state.sensorData![index].vehicleId,
                                  trackingNumber: state.sensorData![index].trackingNumber,
                                  installationLocation: state.sensorData![index].installationLocation,
                                  type: state.sensorData![index].sensorType!.type,
                                  model: state.sensorData![index].sensorType!.model,
                                  description: state.sensorData![index].sensorType!.description,
                                  status: state.sensorData![index].status,
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
