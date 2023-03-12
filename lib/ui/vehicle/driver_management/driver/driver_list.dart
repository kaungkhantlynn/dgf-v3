import 'package:fleetmanagement/bloc/mng/driver_management/driver/action/driver_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/driver/action/driver_action_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../bloc/mng/driver_management/driver/list/driver_bloc.dart';
import 'driver_card.dart';

class DriverList extends StatelessWidget {
  const DriverList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driverBloc = BlocProvider.of<DriverBloc>(context);
    driverBloc.add(GetDriver());

    return
      BlocBuilder<DriverBloc,DriverState>(
      builder: (context,state){

        if (state is DriverLoaded) {
          return
            BlocListener<DriverActionCubit,DriverActionState>(
                listener: (context,state){
                  if (state is DriverActionError) {
                    print('submission failure');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!)),
                    );
                  }
                  if (state is DriverActionFinished) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(translate('successful'))),
                    );
                    Future.delayed(Duration(seconds: 1), () async {
                      Navigator.pop(context,true);
                    });
                  }
                },
              child:
              ListView.builder(
                  itemCount: state.driverDatas!.length,
                  itemBuilder: (context,index){
                    return DriverCard(
                      date: state.driverDatas![index].updatedAt,
                      licenseNumber: state.driverDatas![index].licenseNumber,
                      name: state.driverDatas![index].name,
                      licenseType: state.driverDatas![index].licenseType,
                      status: state.driverDatas![index].status,
                      id: state.driverDatas![index].id,
                    );
                  }
              ),
            );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

