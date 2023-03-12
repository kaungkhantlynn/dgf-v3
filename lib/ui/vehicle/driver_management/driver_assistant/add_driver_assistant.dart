import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/assistant/action/assistant_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/assistant/action/assistant_action_state.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_assistant/driver_assistant.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../bloc/mng/driver_management/assistant/list/assistant_bloc.dart';
import '../../../../di/components/service_locator.dart';
import '../../vehicle_management/vehicle/component/status_picker.dart';
import 'component/license_type_picker.dart';

class AddDriverAssistant extends StatefulWidget {
  static const String route = '/add_driver_assistant';
  const AddDriverAssistant({Key? key}) : super(key: key);

  @override
  _AddDriverAssistantState createState() => _AddDriverAssistantState();
}

class _AddDriverAssistantState extends State<AddDriverAssistant> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssistantActionCubit>(create: (context)=> AssistantActionCubit(getIt<MngApi>()),
    child: Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.add_driver_assistant'),
      ),
      body: SingleChildScrollView(
        child: AssistantForm()
      ),
    ),);
  }
}

class AssistantForm extends StatefulWidget {
  const AssistantForm({Key? key}) : super(key: key);

  @override
  _AssistantFormState createState() => _AssistantFormState();
}

class _AssistantFormState extends State<AssistantForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController licenseTypeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  bool isChecked = false;
  String? status = "InActive";


  @override
  Widget build(BuildContext context) {

    final assistantAction = BlocProvider.of<AssistantActionCubit>(context);

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
    return BlocConsumer<AssistantActionCubit,AssistantActionState>(
        listener: (context, state) {
          if (state is AssistantActionError) {
            print('submission failure');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }  if (state is AssistantActionFinished) {
            print('successsubmission');
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, DriverAssistant.route);
            });

            // Future.delayed(Duration.zero, () async {
            //   Navigator.pop(context,true);
            // });
          }
        },
        builder:(context,state){
          return   Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: licenseNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_license_number');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.license_number'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: InkWell(
                      onTap: (){
                        _navigateLicenseTypeSelector(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: licenseTypeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_license_type');
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: translate('vehicle_management_page.license_type'),
                        ),
                      ),
                    )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: InkWell(
                        onTap: (){
                          _navigateStatusSelector(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: statusController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('vehicle_management_page.please_enter_status');
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: translate('vehicle_management_page.status'),
                          ),
                        ),
                      )
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
                                  "name" : nameController.text,
                                  "license_number" : licenseNumberController.text,
                                  "license_type" : licenseTypeController.text,
                                  "status" : statusController.text
                                });
                                assistantAction.create(formData);
                                context.read<AssistantBloc>().add(RefreshAssistant());

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

  _navigateLicenseTypeSelector(BuildContext context) async {
    final selectedLicenseType = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LicenseTypePicker()),
    );

    licenseTypeController.text = selectedLicenseType;
  }

  _navigateStatusSelector(BuildContext context) async {
    final selectedStatus = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatusPicker()),
    );

    statusController.text = selectedStatus;
  }
}
