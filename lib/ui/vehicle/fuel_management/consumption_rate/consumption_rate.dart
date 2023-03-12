import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/action/action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/action/action_state.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/list/fuel_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/add_consumption_rate.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/consumption_rate_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class ConsumptionRate extends StatefulWidget {
  static const String route = '/consumption_rate';
  const ConsumptionRate({Key? key}) : super(key: key);

  @override
  _ConsumptionRateState createState() => _ConsumptionRateState();
}

class _ConsumptionRateState extends State<ConsumptionRate> {
  FuelBloc fuelBloc=FuelBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    fuelBloc.add(GetFuel());

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
    final action = BlocProvider.of<ActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.consumption_rate'),
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
                      Navigator.pushNamed(context, AddConsumptionRate.route);
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
            BlocBuilder<FuelBloc,FuelState>(
              bloc: fuelBloc,
              builder: (context,state){
                if(state is FuelLoaded){
                  print("FUEL IS LOADED");
                  return
                    BlocListener<ActionCubit,ActionState>(
                        listener: (context, state){
                          if (state is ActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is ActionFinished) {
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
                              itemCount: state.fuelDatas!.length,
                              itemBuilder: (context,index){
                                return ConsumptionRateCard(
                                  id:state.fuelDatas![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.fuelDatas![index].createdAt!),
                                  license: state.fuelDatas![index].vehicle!=null ?state.fuelDatas![index].vehicle!.license:'-',
                                  chassisNumber:state.fuelDatas![index].vehicle!=null ?state.fuelDatas![index].vehicle!.chassisNumber:'-',
                                  province: state.fuelDatas![index].vehicle!=null ?state.fuelDatas![index].vehicle!.province:'-',
                                  lowLoad: state.fuelDatas![index].lowLoad,
                                  mediumLoad: state.fuelDatas![index].mediumLoad,
                                  highLoad: state.fuelDatas![index].highLoad,
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
