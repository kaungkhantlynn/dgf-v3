import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/act/action/act_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/act/action/act_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/wsu.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/wsu_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';


class AddWsu extends StatefulWidget {
  static const String route = '/add_wsu';
  const AddWsu({Key? key}) : super(key: key);

  @override
  _AddWsuState createState() => _AddWsuState();
}

class _AddWsuState extends State<AddWsu> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<ActActionCubit>(create: (context)=> ActActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.add_wsu'),
        ),
        body: SingleChildScrollView(
            child: WsuForm()
        ),
      ),);

  }
}
class WsuForm extends StatefulWidget {
  const WsuForm({Key? key}) : super(key: key);

  @override
  _WsuFormState createState() => _WsuFormState();
}

class _WsuFormState extends State<WsuForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final actAction = BlocProvider.of<ActActionCubit>(context);
    return BlocConsumer<ActActionCubit,ActActionState>(
        listener: (context, state) {
          if (state is ActActionError) {
            print(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is ActActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, Wsu.route);
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

                  //start date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: startDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_start_date');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '${translate('vehicle_management_page.start_date')} (example: 2022-03-01)',
                          hintText: translate('vehicle_management_page.year_month_day')
                      ),
                    ),
                  ),

                  //end date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_end_date');
                        }
                        return null;
                      },
                      controller: endDateController,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '${translate('vehicle_management_page.end_date')} (example: 2022-03-01)',
                          hintText:  translate('vehicle_management_page.year_month_day')
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
                                  "vehicle_id":  vehicleIdController.text,
                                  "start_date": startDateController.text,
                                  "end_date": endDateController.text
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

