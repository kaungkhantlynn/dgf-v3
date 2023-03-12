import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';
import 'insurance_card.dart';


class EditInsurance extends StatefulWidget {
  static const String route = '/edit_insurance';
  const EditInsurance({Key? key}) : super(key: key);

  @override
  _EditInsuranceState createState() => _EditInsuranceState();
}

class _EditInsuranceState extends State<EditInsurance> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<InsuranceActionCubit>(create: (context)=> InsuranceActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('edit_insurance'),
        ),
        body: SingleChildScrollView(
            child: EditInsuranceForm()
        ),
      ),);

  }
}
class EditInsuranceForm extends StatefulWidget {
  const EditInsuranceForm({Key? key}) : super(key: key);

  @override
  _EditInsuranceFormState createState() => _EditInsuranceFormState();
}

class _EditInsuranceFormState extends State<EditInsuranceForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool isChecked = false;
  String? status;
  bool firstTime=true;

  setData(state){
    setState(() {
      vehicleIdController.text=state.insuranceData!.vehicleId.toString();
      companyController.text=state.insuranceData!.company.toString();
      startDateController.text=state.insuranceData!.startDate.toString();
      endDateController.text=state.insuranceData!.endDate.toString();
      firstTime=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as InsuranceArguments;
    final insuranceAction = BlocProvider.of<InsuranceActionCubit>(context);
    insuranceAction.show(args.id);
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
          if (state is InsuranceActionShowed) {
            if(firstTime){
              WidgetsBinding.instance.addPostFrameCallback((_){
                setData(state);
              });
            }
          }
          else if(state is InsuranceActionLoading){
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
                      // keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '${translate('vehicle_management_page.start_date')} (example: 2022-03-01)',
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
                                  "vehicle_id":  vehicleIdController.text,
                                  "company": companyController.text,
                                  "start_date": startDateController.text,
                                  "end_date": endDateController.text
                                };
                                insuranceAction.update(jsonData,args.id);

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
}

