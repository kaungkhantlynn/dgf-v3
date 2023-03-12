import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/driver_management/driver/action/driver_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/driver/list/driver_bloc.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/add_driver.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/driver_list.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../data/network/api/mng/mng_api.dart';

class Driver extends StatefulWidget {
  static const String route = '/driver';
  const Driver({Key? key}) : super(key: key);

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {

  double progress =0;
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return MultiBlocProvider(
      providers: [

        BlocProvider<DriverBloc>(create: (context)=> DriverBloc(getIt<MngApi>())),
        BlocProvider<DriverActionCubit>(create: (context)=> DriverActionCubit(getIt<MngApi>())),
      ],child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.driver'),
        ),
        body: DriverBody()
    ),);
  }
}

class DriverBody extends StatelessWidget {
  const DriverBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driverAction = BlocProvider.of<DriverActionCubit>(context);
    return Column(
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

                  driverAction.export();
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
                  Navigator.pushNamed(context, AddDriver.route);
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

        Expanded(
            child: DriverList()
        ),
      ],
    );
  }
}

