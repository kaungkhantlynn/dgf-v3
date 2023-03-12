import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_state.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/list/fuel_type_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/add_fuel_type.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/fuel_type_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class FuelType extends StatefulWidget {
  static const String route = '/fuel_type';
  const FuelType({Key? key}) : super(key: key);

  @override
  _FuelTypeState createState() => _FuelTypeState();
}

class _FuelTypeState extends State<FuelType> {
  FuelTypeBloc fuelTypeBloc=FuelTypeBloc(getIt<MngApi>());

  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }

  @override
  void initState(){
    super.initState();
    fuelTypeBloc.add(GetFuelType());

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
    final action = BlocProvider.of<FuelTypeActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.fuel_type'),
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
                      Navigator.pushNamed(context, AddFuelType.route);
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
            BlocBuilder<FuelTypeBloc,FuelTypeState>(
              bloc: fuelTypeBloc,
              builder: (context,state){
                if(state is FuelTypeLoaded){
                  return
                    BlocListener<FuelTypeActionCubit,FuelTypeActionState>(
                      listener: (context, state){
                        if (state is FuelTypeActionError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error!)),
                          );
                        }
                        if (state is FuelTypeActionFinished) {
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
                            itemCount: state.fuelTypeDatas!.length,
                            itemBuilder: (context,index){
                              print("THIS IS length ${state.fuelTypeDatas!.length}");
                              return FuelTypeCard(
                                id:state.fuelTypeDatas![index].id,
                                date: DateFormat("yyyy-MM-dd").parse(state.fuelTypeDatas![index].createdAt!),
                                type: state.fuelTypeDatas![index].type,
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
