import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';

class AddInsurance extends StatefulWidget {
  static const String route = '/add_insurance';
  const AddInsurance({Key? key}) : super(key: key);

  @override
  _AddInsuranceState createState() => _AddInsuranceState();
}

class _AddInsuranceState extends State<AddInsurance> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<InsuranceActionCubit>(create: (context)=> InsuranceActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.add_insurance'),
        ),
        body: SingleChildScrollView(
            child: InsuranceForm()
        ),
      ),);

  }
}
class InsuranceForm extends StatefulWidget {
  const InsuranceForm({Key? key}) : super(key: key);

  @override
  _InsuranceFormState createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<InsuranceForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool isChecked = false;
  String? status;

  @override
  Widget build(BuildContext context) {
    final insuranceAction = BlocProvider.of<InsuranceActionCubit>(context);
    return BlocConsumer<InsuranceActionCubit,InsuranceActionState>(
        listener: (context, state) {
          if (state is InsuranceActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is InsuranceActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, Insurance.route);
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

                  //company
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: companyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_company');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.company'),
                      ),
                    ),
                  ),

                  //start date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.start_date');
                        }
                        return null;
                      },
                      controller: startDateController,
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
                      controller: endDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_end_date');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '${translate('vehicle_management_page.end_date')} (example: 2022-03-01)',
                          hintText: translate('vehicle_management_page.year_month_day')
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
                                  "company": companyController.text,
                                  "start_date": startDateController.text,
                                  "end_date": endDateController.text
                                });
                                insuranceAction.create(formData);

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

