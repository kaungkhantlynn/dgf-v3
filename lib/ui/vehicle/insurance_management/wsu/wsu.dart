import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/insurance_management/act/action/act_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/act/action/act_action_state.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/act/list/act_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/add_wsu.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/wsu_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class Wsu extends StatefulWidget {
  static const String route = '/wsu';
  const Wsu({Key? key}) : super(key: key);

  @override
  _WsuState createState() => _WsuState();
}

class _WsuState extends State<Wsu> {
  ActBloc actBloc=ActBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    actBloc.add(GetAct());

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
    final action = BlocProvider.of<ActActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.wsu'),
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
                      Navigator.pushNamed(context, AddWsu.route);
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
            BlocBuilder<ActBloc,ActState>(
              bloc: actBloc,
              builder: (context,state){
                if(state is ActLoaded){
                  return
                    BlocListener<ActActionCubit,ActActionState>(
                        listener: (context, state){
                          if (state is ActActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is ActActionFinished) {
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
                              itemCount: state.actDatas!.length,
                              itemBuilder: (context,index){
                                print("Vechcle fkjdak");
                                print(state.actDatas![index].vehicle);
                                return WsuCard(
                                  id:state.actDatas![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.actDatas![index].createdAt!),
                                  name: state.actDatas![index].vehicle!=null ?state.actDatas![index].vehicle!.name:'-',
                                  vehicleId: state.actDatas![index].vehicleId,
                                  license: state.actDatas![index].vehicle!=null ?state.actDatas![index].vehicle!.license:'-',
                                  brand: state.actDatas![index].vehicle!=null ?state.actDatas![index].vehicle!.brand:'-',
                                  startDate: DateFormat("yyyy-MM-dd").parse(state.actDatas![index].startDate!),
                                  endDate: DateFormat("yyyy-MM-dd").parse(state.actDatas![index].endDate!),

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
