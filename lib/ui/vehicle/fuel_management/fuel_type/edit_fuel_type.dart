import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/fuel_type.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'fuel_type_card.dart';


class EditFuelType extends StatefulWidget {
  static const String route = '/edit_fuel_type';
  const EditFuelType({Key? key}) : super(key: key);

  @override
  _EditFuelTypeState createState() => _EditFuelTypeState();
}

class _EditFuelTypeState extends State<EditFuelType> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.edit_fuel_type'),
      ),
      body: SingleChildScrollView(
          child: FuelTypeForm()
      ),
    );

  }
}
class FuelTypeForm extends StatefulWidget {
  const FuelTypeForm({Key? key}) : super(key: key);

  @override
  _FuelTypeFormState createState() => _FuelTypeFormState();
}

class _FuelTypeFormState extends State<FuelTypeForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController typeController = TextEditingController();
  bool firstTime=true;

  setData(state){
    setState(() {
      typeController.text=state.fuelTypeData!.type.toString();
      firstTime=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as FuelTypeArguments;
    final fuelTypeAction = BlocProvider.of<FuelTypeActionCubit>(context);
    fuelTypeAction.show(args.id);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return BlocConsumer<FuelTypeActionCubit,FuelTypeActionState>(
        listener: (context, state) {
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
              Navigator.pushReplacementNamed(context, FuelType.route);
            });

          }
        },
        builder:(context,state){
          if (state is FuelTypeActionShowed) {
            if(firstTime){
              WidgetsBinding.instance.addPostFrameCallback((_){
                setData(state);
              });
            }
          }
          else if(state is FuelTypeActionLoading){
            print("IS LOADING");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //type
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: typeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_type');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.type'),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(12)),
                  Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue.shade700,
                              padding: const EdgeInsets.all(15.5),
                              textStyle: const TextStyle(fontSize: 17),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                var jsonData={
                                  "type": typeController.text,
                                };
                                fuelTypeAction.update(jsonData,args.id);

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(translate('need_to_validate'))),
                                );
                              }
                            },
                            child: Text(
                              translate('update'),
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            )),
                      ))
                ],
              )
          );
        });
  }
}

