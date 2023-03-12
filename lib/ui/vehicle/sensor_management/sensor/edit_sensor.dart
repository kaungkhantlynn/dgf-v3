import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/sensor_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';


class EditSensor extends StatefulWidget {
  static const String route = '/edit_sensor';
  const EditSensor({Key? key}) : super(key: key);

  @override
  _EditSensorState createState() => _EditSensorState();
}

class _EditSensorState extends State<EditSensor> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<SensorActionCubit>(create: (context)=> SensorActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.edit_sensor'),
        ),
        body: SingleChildScrollView(
            child: EditSensorForm()
        ),
      ),);

  }
}
class EditSensorForm extends StatefulWidget {
  const EditSensorForm({Key? key}) : super(key: key);

  @override
  _EditSensorFormState createState() => _EditSensorFormState();
}

class _EditSensorFormState extends State<EditSensorForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController trackingNumberController = TextEditingController();
  TextEditingController sensorTypeIdController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController installationLocationController = TextEditingController();
  bool isChecked = false;
  String? status;
  bool firstTime=true;

  setData(state){
    setState(() {
      vehicleIdController.text=state.sensorData!.vehicleId.toString();
      trackingNumberController.text=state.sensorData!.trackingNumber.toString();
      sensorTypeIdController.text=state.sensorData!.sensorTypeId.toString();
      serialController.text=state.sensorData!.serial.toString();
      installationLocationController.text=state.sensorData!.installationLocation.toString();
      status=state.sensorData!.status;
      if (state.sensorData!.status == "Active") {
        isChecked = true;
      }  else {
        isChecked = false;
      }
      firstTime=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as SensorArguments;
    final sensorAction = BlocProvider.of<SensorActionCubit>(context);
    sensorAction.show(args.id);
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
    return BlocConsumer<SensorActionCubit,SensorActionState>(
        listener: (context, state) {
          if (state is SensorActionError) {
            print('submission failure');
            print(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is SensorActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, Sensor.route);
            });

          }
        },
        builder:(context,state){
          if (state is SensorActionShowed) {
            if(firstTime){
              WidgetsBinding.instance.addPostFrameCallback((_){
                setData(state);
              });
            }
          }
          else if(state is SensorActionLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
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

                  //tracking number
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: trackingNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  translate('vehicle_management_page.please_enter_tracking_number');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.tracking_number'),
                      ),
                    ),
                  ),

                  //sensor type
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  translate('vehicle_management_page.please_enter_sensor_type_id');
                        }
                        return null;
                      },
                      controller: sensorTypeIdController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.sensor_type_id'),
                      ),
                    ),
                  ),

                  //serial
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: serialController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  translate('vehicle_management_page.please_enter_serial_no');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.serial_number'),
                      ),
                    ),
                  ),


                  //installation location
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: installationLocationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_installation_location');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.installation_location'),
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
                          translate('check_ready_not_ready'),
                          style: TextStyle(fontSize: 17.0),
                        ), //Text
                        SizedBox(width: 10), //SizedBox
                        /** Checkbox Widget **/
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                            if (isChecked) {
                              setState(() {
                                status = "Active";
                              });
                            }  else{
                              setState(() {
                                status = "InActive";
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
                                var jsonData = {
                                  "vehicle_id":  vehicleIdController.text,
                                  "tracking_number": trackingNumberController.text,
                                  "sensor_type_id": sensorTypeIdController.text,
                                  "serial": serialController.text,
                                  "status": status,
                                  "installation_location": installationLocationController.text
                                };
                                sensorAction.update(jsonData,args.id);

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

