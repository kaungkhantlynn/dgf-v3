import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/action/vehicle_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/action/vehicle_type_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';


class AddVehicleType extends StatefulWidget {
  static const String route = '/add_vehicle_type';
  const AddVehicleType({Key? key}) : super(key: key);

  @override
  _AddVehicleTypeState createState() => _AddVehicleTypeState();
}

class _AddVehicleTypeState extends State<AddVehicleType> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<VehicleTypeActionCubit>(create: (context)=> VehicleTypeActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('add_vehicle_type'),
        ),
        body: SingleChildScrollView(
            child: VehicleTypeForm()
        ),
      ),);

  }
}
class VehicleTypeForm extends StatefulWidget {
  const VehicleTypeForm({Key? key}) : super(key: key);

  @override
  _VehicleTypeFormState createState() => _VehicleTypeFormState();
}

class _VehicleTypeFormState extends State<VehicleTypeForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController typeController = TextEditingController();
  TextEditingController maxSpeedController = TextEditingController();
  TextEditingController alarmIntervalController = TextEditingController();
  TextEditingController iconColorController = TextEditingController();
  TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vehicleTypeAction = BlocProvider.of<VehicleTypeActionCubit>(context);
    return BlocConsumer<VehicleTypeActionCubit,VehicleTypeActionState>(
        listener: (context, state) {
          if (state is VehicleTypeActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is VehicleTypeActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, VehicleType.route);
              // Navigator.pop(context,true);
            });
          }
        },
        builder:(context,state){
          return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //type id
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
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Type',
                      ),
                    ),
                  ),

                  //max speed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: maxSpeedController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  translate('vehicle_management_page.please_enter_maximum_speed');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.maximum_speed'),
                      ),
                    ),
                  ),

                  //alarm interval
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_alarm_interval');
                        }
                        return null;
                      },
                      controller: alarmIntervalController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.alarm_interval'),
                      ),
                    ),
                  ),

                  //icon color
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: iconColorController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_icon_color');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${translate('vehicle_management_page.icon_color')}  (example: #2986cc)',
                      ),
                    ),
                  ),


                  //icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: iconController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  translate('vehicle_management_page.please_enter_icon');
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${translate('vehicle_management_page.icon')} (example: fa fa-truck-moving fa-1x)',
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
                                  "maximum_speed": maxSpeedController.text,
                                  "alarm_interval": alarmIntervalController.text,
                                  "icon_color": iconColorController.text,
                                  "icon": iconController.text
                                });
                                vehicleTypeAction.create(formData);

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Need to validate')),
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

