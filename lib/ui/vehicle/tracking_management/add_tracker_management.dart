import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/tracker_management_card.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/tracking_management.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';


class AddTrackerManagement extends StatefulWidget {
  static const String route = '/add_tracker_management';
  const AddTrackerManagement({Key? key}) : super(key: key);

  @override
  _AddTrackerManagementState createState() => _AddTrackerManagementState();
}

class _AddTrackerManagementState extends State<AddTrackerManagement> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<TrackerActionCubit>(create: (context)=> TrackerActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: 'app_bar.add_tracker',
        ),
        body: SingleChildScrollView(
            child: TrackerForm()
        ),
      ),);

  }
}
class TrackerForm extends StatefulWidget {
  const TrackerForm({Key? key}) : super(key: key);

  @override
  _TrackerFormState createState() => _TrackerFormState();
}

class _TrackerFormState extends State<TrackerForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  bool isChecked = false;
  String status= 'Not Ready';

  @override
  Widget build(BuildContext context) {
    final driverAction = BlocProvider.of<TrackerActionCubit>(context);
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
    return BlocConsumer<TrackerActionCubit,TrackerActionState>(
        listener: (context, state) {
          if (state is TrackerActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          else if (state is TrackerActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, TrackerManagement.route);
              // Navigator.pop(context,true);
            });

          }
        },
        builder:(context,state){
          return  Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //vehicle id
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: vehicleIdController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_vehicle_id');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.vehicle_id'),
                      ),
                    ),
                  ),

                  //name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_name');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.name'),
                      ),
                    ),
                  ),

                  //serial
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: serialController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_serial_no');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.serial_number'),
                      ),
                    ),
                  ),

                  //brand
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_brand');
                        }
                        return null;
                      },
                      controller: brandController,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.brand'),
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
                        hintText: 'e.g - Tongli',
                        labelText: translate('vehicle_management_page.model'),
                      ),
                    ),
                  ),

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

                  //status
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child:Row(
                      children: <Widget>[
                        //SizedBox
                        Text(
                          translate('vehicle_management_page.check_ready_not_ready'),
                          style: TextStyle(fontSize: 17.0),
                        ), //Text
                        SizedBox(width: 10), //SizedBox
                        /** Checkbox Widget **/
                        Checkbox(

                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            print("THis is changed");
                            setState(() {
                              isChecked = value!;
                            });
                            if (isChecked) {
                              setState(() {
                                status = 'Ready';
                              });
                            }  else{
                              setState(() {
                                status = 'Not Ready';
                              });
                            }
                          },
                        ) //Checkbox
                      ], //<Widget>[]
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
                                  "vehicle_id":  vehicleIdController.text,
                                  "name": nameController.text,
                                  "serial":  serialController.text,
                                  "brand": brandController.text,
                                  "model": modelController.text,
                                  "type": typeController.text,
                                  "status": status
                                });
                                driverAction.create(formData);
                                print("HEYYY LOOKKK!!");

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text(translate('vehicle_management_page.need_to_validate'))),
                                );
                              }
                            },
                            child: Text(
                              translate('vehicle_management_page.add'),
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            )),
                      ))
                ],
              )
          );
        });
  }
}

