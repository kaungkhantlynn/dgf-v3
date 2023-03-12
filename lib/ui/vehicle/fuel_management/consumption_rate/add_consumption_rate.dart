import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/action/action_state.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/consumption_rate.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/action/action_bloc.dart';

import 'consumption_rate_card.dart';


class AddConsumptionRate extends StatefulWidget {
  static const String route = '/add_consumption_rate';
  const AddConsumptionRate({Key? key}) : super(key: key);

  @override
  _AddConsumptionRateState createState() => _AddConsumptionRateState();
}

class _AddConsumptionRateState extends State<AddConsumptionRate> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<ActionCubit>(create: (context)=> ActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.add_consumption_rate'),
        ),
        body: SingleChildScrollView(
            child: ConsumptionRateForm()
        ),
      ),);

  }
}
class ConsumptionRateForm extends StatefulWidget {
  const ConsumptionRateForm({Key? key}) : super(key: key);

  @override
  _ConsumptionRateFormState createState() => _ConsumptionRateFormState();
}

class _ConsumptionRateFormState extends State<ConsumptionRateForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController fuelIdController = TextEditingController();
  TextEditingController lowLoadController = TextEditingController();
  TextEditingController mediumLoadController = TextEditingController();
  TextEditingController highLoadController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final actAction = BlocProvider.of<ActionCubit>(context);
    return BlocConsumer<ActionCubit,ActionState>(
        listener: (context, state) {
          if (state is ActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is ActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration.zero, () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, ConsumptionRate.route);
            });
          }
        },
        builder:(context,state){
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

                  //fuel id
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: fuelIdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_fuel_id');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.fuel_id'),
                      ),
                    ),
                  ),

                  //low load
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: lowLoadController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_low_load');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.low_load'),
                      ),
                    ),
                  ),

                  //medium load
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_medium_load');
                        }
                        return null;
                      },
                      controller: mediumLoadController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.medium_load'),
                      ),
                    ),
                  ),

                  //high load
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: highLoadController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_high_load');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.high_load'),
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
                                  "vehicle_id": vehicleIdController.text,
                                  "fuel_id": fuelIdController.text,
                                  "low_load": lowLoadController.text,
                                  "medium_load": mediumLoadController.text,
                                  "high_load":highLoadController.text
                                });
                                actAction.create(formData);

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

