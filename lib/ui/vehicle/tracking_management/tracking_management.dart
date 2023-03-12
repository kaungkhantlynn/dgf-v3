import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_state.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/list/tracker_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/add_tracker_management.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/tracker_management_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class TrackerManagement extends StatefulWidget {
  static const String route = '/tracker_management';
  const TrackerManagement({Key? key}) : super(key: key);

  @override
  _TrackerManagementState createState() => _TrackerManagementState();
}

class _TrackerManagementState extends State<TrackerManagement> {
  TrackerBloc trackerBloc=TrackerBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    trackerBloc.add(GetTracker());

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
    final action = BlocProvider.of<TrackerActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.tracker_management'),
        ),
        body:
        Column(
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
                      Navigator.pushNamed(context, AddTrackerManagement.route);
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
            BlocBuilder<TrackerBloc,TrackerState>(
              bloc: trackerBloc,
              builder: (context,state){
                if(state is TrackerLoaded){
                  return
                    BlocListener<TrackerActionCubit,TrackerActionState>(
                      listener: (context, state){
                        if (state is TrackerActionError) {
                          print('submission failure');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error!)),
                          );
                        }
                        if (state is TrackerActionFinished) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(translate('successful'))),
                          );
                          Future.delayed(Duration(seconds: 1), () async {
                            Navigator.pop(context,true);
                          });
                        }
                      },
                      child: Expanded(
                        child:
                        ListView.builder(
                            itemCount: state.deviceData!.length,
                            itemBuilder: (context,index){
                              return TrackerManagementCard(
                                id:state.deviceData![index].id,
                                date: DateFormat("yyyy-MM-dd").parse(state.deviceData![index].createdAt!),
                                // date: state.deviceData![index].createdAt,
                                name: state.deviceData![index].name,
                                serialNumber: state.deviceData![index].serial,
                                brand: state.deviceData![index].brand,
                                model: state.deviceData![index].model,
                                type: state.deviceData![index].type,
                                status: state.deviceData![index].status ,
                              );
                            }
                        ),
                      ),
                    );
                }
                return Center(
                  child: CircularProgressIndicator(),);
              },
            ),
          ],
        )
    );
  }
}
