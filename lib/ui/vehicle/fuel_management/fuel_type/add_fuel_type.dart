import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_state.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_cubit.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';
import 'fuel_type.dart';
import 'fuel_type_card.dart';


class AddFuelType extends StatefulWidget {
  static const String route = '/add_fuel_type';
  const AddFuelType({Key? key}) : super(key: key);

  @override
  _AddFuelTypeState createState() => _AddFuelTypeState();
}

class _AddFuelTypeState extends State<AddFuelType> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.add_fuel_type'),
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


  @override
  Widget build(BuildContext context) {
    final fuelTypeAction = BlocProvider.of<FuelTypeActionCubit>(context);
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
              Navigator.pushReplacementNamed(context,FuelType.route);
            });
          }
        },
        builder:(context,state){
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
                                FormData formData = FormData.fromMap({
                                  "type": typeController.text,
                                });
                                fuelTypeAction.create(formData);

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text(translate('need_to_validate'))),
                                );
                              }
                            },
                            child: Text(
                              translate('add'),
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            )),
                      ))
                ],
              )
          );
        });
  }
}

