import 'dart:isolate';
import 'dart:ui';

import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_state.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/list/insurance_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/add_insurance.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class Insurance extends StatefulWidget {
  static const String route = '/insurance';
  const Insurance({Key? key}) : super(key: key);

  @override
  _InsuranceState createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  InsuranceBloc insuranceBloc=InsuranceBloc(getIt<MngApi>());
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id,status,progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id,status,progress]);
  }
  @override
  void initState(){
    super.initState();
    insuranceBloc.add(GetInsurance());

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
    final action = BlocProvider.of<InsuranceActionCubit>(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.insurance'),
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
                      Navigator.pushNamed(context, AddInsurance.route);
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
            BlocBuilder<InsuranceBloc,InsuranceState>(
              bloc: insuranceBloc,
              builder: (context,state){
                if(state is InsuranceLoaded){
                  return
                    BlocListener<InsuranceActionCubit,InsuranceActionState>(
                        listener: (context, state){
                          if (state is InsuranceActionError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state is InsuranceActionFinished) {
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
                              itemCount: state.insuranceData!.length,
                              itemBuilder: (context,index){
                                return InsuranceCard(
                                  id: state.insuranceData![index].id,
                                  date: DateFormat("yyyy-MM-dd").parse(state.insuranceData![index].createdAt!),
                                  company: state.insuranceData![index].company,
                                  name: state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.name:'-',
                                  chassisNumber: state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.chassisNumber:'-',
                                  license: state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.license:'-',
                                  province: state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.province:'-',
                                  color: state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.color:'-',
                                  brand:state.insuranceData![index].vehicle!=null ?state.insuranceData![index].vehicle!.brand:'-',
                                  startDate: DateFormat("yyyy-MM-dd").parse(state.insuranceData![index].startDate!),
                                  endDate: DateFormat("yyyy-MM-dd").parse(state.insuranceData![index].endDate!),
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
