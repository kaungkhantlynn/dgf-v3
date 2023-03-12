import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/action/sensor_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/action/sensor_type_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/sensor_type.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';


class AddSensorType extends StatefulWidget {
  static const String route = '/add_sensor_type';
  const AddSensorType({Key? key}) : super(key: key);

  @override
  _AddSensorTypeState createState() => _AddSensorTypeState();
}

class _AddSensorTypeState extends State<AddSensorType> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<SensorTypeActionCubit>(create: (context)=> SensorTypeActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.add_sensor_type'),
        ),
        body: SingleChildScrollView(
            child: SensorTypeForm()
        ),
      ),);

  }
}
class SensorTypeForm extends StatefulWidget {
  const SensorTypeForm({Key? key}) : super(key: key);

  @override
  _SensorTypeFormState createState() => _SensorTypeFormState();
}

class _SensorTypeFormState extends State<SensorTypeForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController typeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sensorTypeAction = BlocProvider.of<SensorTypeActionCubit>(context);
    return BlocConsumer<SensorTypeActionCubit,SensorTypeActionState>(
        listener: (context, state) {
          if (state is SensorTypeActionError) {
            print('submission failure');
            print(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is SensorTypeActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, SensorType.route);
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

                  //model
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: modelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_model');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.model'),
                      ),
                    ),
                  ),

                  //description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_description');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.description'),
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
                                  "model": modelController.text,
                                  "description": descriptionController.text,
                                });
                                sensorTypeAction.create(formData);
                                print("HEYYY LOOKKK!!");

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

