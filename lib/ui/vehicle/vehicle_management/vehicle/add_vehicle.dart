import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/action/vehicle_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/action/vehicle_action_state.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/vehicle.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../di/components/service_locator.dart';
import 'component/brand_picker.dart';
import 'component/color_picker.dart';
import 'component/department_picker.dart';
import 'component/provinces_picker.dart';
import 'component/status_picker.dart';

class AddVehicle extends StatefulWidget {
  static const String route = '/add_vehicle';
  const AddVehicle({Key? key}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<VehicleActionCubit>(create: (context)=> VehicleActionCubit(getIt<MngApi>()),
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.add_vehicle'),
        ),
        body: SingleChildScrollView(
            child: VehicleForm()
        ),
      ),);

  }
}
class VehicleForm extends StatefulWidget {
  const VehicleForm({Key? key}) : super(key: key);

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();
  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController userDepartmentIdController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  late int userDepartmentId;
  bool isChecked = false;
  String? status = "InActive";

  @override
  Widget build(BuildContext context) {
    final vehicleAction = BlocProvider.of<VehicleActionCubit>(context);
    var selectedProvinces;
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
    return BlocConsumer<VehicleActionCubit, VehicleActionState>(
        listener: (context, state) {
          if (state is VehicleActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state is VehicleActionFinished) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(translate('successful'))),
            );

            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pop(context, true);
              Navigator.pushReplacementNamed(context, Vehicle.route);
            });
          }
        },
        builder: (context, state) {
          return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
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

                  //license
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: licenseController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_license');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:  translate('vehicle_management_page.license'),
                      ),
                    ),
                  ),

                  //province
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: InkWell(
                        onTap: () {
                          _navigateProvincesSelecter(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: provinceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('vehicle_management_page.please_enter_province');
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade200,),
                            border: UnderlineInputBorder(),
                            labelText: translate('vehicle_management_page.province'),
                          ),
                        ),
                      )
                  ),

                  //chassis number
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_chassis_number');
                        }
                        return null;
                      },
                      controller: chassisNumberController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.chassisNumber'),
                      ),
                    ),
                  ),

                  //vehicle id
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: vehicleIdController,
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

                  //color
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: InkWell(
                      onTap: (){
                        _navigateColorSelecter(context);
                      },
                      child:  TextFormField(
                        enabled: false,
                        controller: colorController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_color');
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade200,),
                          border: UnderlineInputBorder(),
                          labelText: translate('vehicle_management_page.color'),
                        ),
                      ),
                    )
                  ),

                  //brand
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: InkWell(
                      onTap: (){
                        _navigateBrandSelecter(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: brandController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_brand');
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade200,),
                          border: UnderlineInputBorder(),
                          labelText: translate('vehicle_management_page.brand'),
                        ),
                      ),
                    )
                  ),

                  //model
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: TextFormField(
                      controller: modelController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate('vehicle_management_page.please_enter_model');
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: translate('vehicle_management_page.model'),
                      ),
                    ),
                  ),

                  //user department id
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: InkWell(
                      onTap: (){
                        _navigateDepartmentSelecter(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: userDepartmentIdController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('vehicle_management_page.please_enter_department');
                          }
                          return null;
                        },
                        
                        decoration:  InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade200,),
                          border: UnderlineInputBorder(),
                          labelText: translate('vehicle_management_page.user_department_id'),
                        ),
                      ),
                    )
                  ),

                  //status
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
                            labelText: translate('status'),
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
                                  "name": nameController.text,
                                  "license": licenseController.text,
                                  "province": provinceController.text,
                                  "chassis_number": chassisNumberController
                                      .text,
                                  "vehicle_type_id": vehicleIdController.text,
                                  "color": colorController.text,
                                  "brand": brandController.text,
                                  "model": modelController.text,
                                  "status": status,
                                  "user_departments_id": userDepartmentId
                                });
                                vehicleAction.create(formData);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                      content: Text(translate('need_to_validate'))),
                                );
                              }
                            },
                            child: Text(
                              translate('add'),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17),
                            )),
                      )),
                  Padding(padding: EdgeInsets.all(12)),
                ],
              )
          );
        });
  }

  _navigateProvincesSelecter(BuildContext context) async {
    final selectedProvince = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProvincesPicker()),
    );

    provinceController.text = selectedProvince;
  }

  _navigateColorSelecter(BuildContext context) async {
    final selectedColor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ColorPicker()),
    );

    colorController.text = selectedColor;
  }

  _navigateBrandSelecter(BuildContext context) async {
    final selectedBrand = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BrandPicker()),
    );

    brandController.text = selectedBrand;
  }

  _navigateDepartmentSelecter(BuildContext context) async {
    final selectedDepartments = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepartmentPicker()),
    );

    userDepartmentIdController.text = selectedDepartments[1];
    userDepartmentId = selectedDepartments[0];
    print('USERDEPID $userDepartmentId');
  }

  _navigateStatusSelector(BuildContext context) async {
    final selectedStatus = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatusPicker()),
    );

    statusController.text = selectedStatus;
  }
}

