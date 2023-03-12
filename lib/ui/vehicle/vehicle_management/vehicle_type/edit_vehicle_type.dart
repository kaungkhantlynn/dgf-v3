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
import '../vehicle/component/color_picker.dart';


class EditVehicleType extends StatefulWidget {
  static const String route = '/edit_vehicle_type';
  const EditVehicleType({Key? key}) : super(key: key);

  @override
  _EditVehicleTypeState createState() => _EditVehicleTypeState();
}

class _EditVehicleTypeState extends State<EditVehicleType> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<VehicleTypeActionCubit>(create: (context)=> VehicleTypeActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.edit_vehicle_type'),
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
  bool firstTime=true;

  setData(state){
    setState(() {
      typeController.text=state.vehicleTypeData!.type.toString();
      maxSpeedController.text=state.vehicleTypeData!.maximumSpeed.toString();
      alarmIntervalController.text=state.vehicleTypeData!.alarmInterval.toString();
      iconColorController.text=state.vehicleTypeData!.iconColor.toString();
      iconController.text=state.vehicleTypeData!.icon.toString();
      firstTime=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as VehicleTypeArguments;
    final vehicleTypeAction = BlocProvider.of<VehicleTypeActionCubit>(context);
    vehicleTypeAction.show(args.id);
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
    return BlocConsumer<VehicleTypeActionCubit,VehicleTypeActionState>(
        listener: (context, state) {
          if (state is VehicleTypeActionError) {
            print(state.error);
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
            });
          }
        },
        builder:(context,state){
          if (state is VehicleTypeActionShowed) {
            if(firstTime){
              WidgetsBinding.instance.addPostFrameCallback((_){
                setData(state);
              });
            }
          }
          else if(state is VehicleTypeActionLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.type'),
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
                          return translate('vehicle_management_page.please_enter_maximum_speed');
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
                    child: InkWell(
                      onTap: (){
                        _navigateColorSelecter(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: iconColorController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_icon_color');
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '${ translate('vehicle_management_page.icon_color')}  (example: #2986cc)',
                        ),
                      ),
                    )
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
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${translate('vehicle_management_page.icon')}  (example: fa fa-truck-moving fa-1x)',
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
                                var jsonData = {
                                  "type": typeController.text,
                                  "maximum_speed": maxSpeedController.text,
                                  "alarm_interval": alarmIntervalController.text,
                                  "icon_color": iconColorController.text,
                                  "icon": iconController.text
                                };
                                vehicleTypeAction.update(jsonData,args.id);

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Need to validate')),
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

  _navigateColorSelecter(BuildContext context) async {
    final selectedColor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ColorPicker()),
    );

    iconColorController.text = selectedColor;
  }
}

