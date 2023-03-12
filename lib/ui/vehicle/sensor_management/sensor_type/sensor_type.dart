import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_state.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/action/sensor_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/action/sensor_type_action_state.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/list/sensor_type_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/add_sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/add_sensor_type.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/sensor_type_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class SensorType extends StatefulWidget {
  static const String route = '/sensor_type';
  const SensorType({Key? key}) : super(key: key);

  @override
  _SensorTypeState createState() => _SensorTypeState();
}

class _SensorTypeState extends State<SensorType> {
  SensorTypeBloc sensorTypeBloc=SensorTypeBloc(getIt<MngApi>());

  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    sensorTypeBloc.add(GetSensorType());

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
    final action = BlocProvider.of<SensorTypeActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.sensor_type'),
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
                      Navigator.pushNamed(context, AddSensorType.route);
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
            BlocBuilder<SensorTypeBloc,SensorTypeState>(
              bloc:sensorTypeBloc,
              builder: (context,state){
                if(state is SensorTypeLoaded){
                  return
                    BlocListener<SensorTypeActionCubit,SensorTypeActionState>(
                        listener: (context, state){
                          if (state is SensorTypeActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is SensorTypeActionFinished) {
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
                              itemCount: state.sensorTypeData!.length,
                              itemBuilder: (context,index){
                                return SensorTypeCard(
                                  id:state.sensorTypeData![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.sensorTypeData![index].createdAt!),
                                  type: state.sensorTypeData![index].type,
                                  model: state.sensorTypeData![index].model,
                                  description: state.sensorTypeData![index].description,
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
