import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/driver/action/driver_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/driver.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../bloc/mng/driver_management/driver/action/driver_action_bloc.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';

class AddDriver extends StatefulWidget {
  static const String route = '/add_driver';
  const AddDriver({Key? key}) : super(key: key);

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<DriverActionCubit>(create: (context)=> DriverActionCubit(getIt<MngApi>()),
    child: Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.add_driver'),
      ),
      body: SingleChildScrollView(
          child: DriverForm()
      ),
    ),);

  }
}
class DriverForm extends StatefulWidget {
  const DriverForm({Key? key}) : super(key: key);

  @override
  _DriverFormState createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController licenseTypeController = TextEditingController();
  bool isChecked = false;
  String? status = "InActive";
  @override
  Widget build(BuildContext context) {
    final driverAction = BlocProvider.of<DriverActionCubit>(context);
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
    return BlocConsumer<DriverActionCubit,DriverActionState>(
        listener: (context, state) {
          if (state is DriverActionError) {
            print('submission failure');
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(state.error!)),
            );
          }  if (state is DriverActionFinished) {
            print('DriverActionFinished');
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );

            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context,true);
              Navigator.pushReplacementNamed(context, Driver.route);
            });
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
                       controller: firstNameController,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return translate('vehicle_management_page.please_enter_first_name');
                         }
                         return null;
                       },
                       decoration:  InputDecoration(
                         border: UnderlineInputBorder(),
                         labelText: translate('vehicle_management_page.first_name'),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                     child: TextFormField(
                       controller: lastNameController,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return translate('vehicle_management_page.please_enter_last_name');
                         }
                         return null;
                       },
                       decoration:  InputDecoration(
                         border: UnderlineInputBorder(),
                         labelText:translate('vehicle_management_page.last_name'),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                     child: TextFormField(
                       controller: emailController,
                       decoration:  InputDecoration(labelText: translate('vehicle_management_page.email')),
                       validator: (value) => EmailValidator.validate(value!)? null : translate('vehicle_management_page.please_enter_email'),

                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                     child: TextFormField(
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return translate('vehicle_management_page.please_enter_password');
                         }
                         return null;
                       },
                       obscureText: true,
                       controller: passwordController,
                       decoration:  InputDecoration(
                         border: UnderlineInputBorder(),
                         labelText: translate('vehicle_management_page.password'),
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
                     child: TextFormField(
                       controller: licenseTypeController,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return translate('vehicle_management_page.please_enter_license_type');
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                         border: UnderlineInputBorder(),
                         labelText: translate('vehicle_management_page.please_enter_license_type'),
                       ),
                     ),
                   ),
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
                                 FormData formData = FormData.fromMap({
                                   "first_name" : firstNameController.text,
                                   "last_name" : lastNameController.text,
                                   "email" : emailController.text,
                                   "password": passwordController.text,
                                   "license_number" : licenseNumberController.text,
                                   "license_type" : licenseTypeController.text,
                                   "status" : status
                                 });
                                 driverAction.create(formData);
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

