import 'package:fleetmanagement/bloc/mng/driver_management/assistant/action/assistant_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/assistant/action/assistant_action_state.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/assistant/list/assistant_bloc.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/driver/action/driver_action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../bloc/mng/driver_management/driver/list/driver_bloc.dart';
import 'driver_assistant_card.dart';


class AssistantList extends StatelessWidget {
  const AssistantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assistantBloc = BlocProvider.of<AssistantBloc>(context);
    assistantBloc.add(GetAssistant());

    return BlocBuilder<AssistantBloc,AssistantState>(
      builder: (context,state){

        if (state is AssistantLoaded) {
          return
            BlocListener<AssistantActionCubit,AssistantActionState>(
                listener: (context,state){
                  if (state is AssistantActionError) {
                    print('submission failure');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!)),
                    );
                  }
                  if (state is AssistantActionFinished) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(translate('successful'))),
                    );
                    Future.delayed(Duration(seconds: 1), () async {
                      Navigator.pop(context,true);
                    });
                  }
                },
              child: ListView.builder(
                  itemCount: state.assistantDatas!.length,
                  itemBuilder: (context,index){
                    return DriverAssistantCard(
                      name: state.assistantDatas![index].name,
                      status: state.assistantDatas![index].status,
                      licenseNumber: state.assistantDatas![index].licenseNumber,
                      date: state.assistantDatas![index].createdAt,
                      id: state.assistantDatas![index].id,
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
