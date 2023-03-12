import 'package:fleetmanagement/bloc/mng/vehicle_management/config/config_bloc.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/widgets/language_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';

import '../../../../../data/network/api/mng/mng_api.dart';
import '../../../../widgets/appbar_page.dart';

class StatusPicker extends StatefulWidget {

  StatusPicker({Key? key})
      : super(key: key);

  @override
  _StatusPickerState createState() => _StatusPickerState();
}


class _StatusPickerState extends State<StatusPicker> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String selectedStatus = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppbarPage(
        title: translate('app_bar.status'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 40),
                    height: size.height - 130,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 1,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.close)),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      translate('vehicle_management_page.select_status'),
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 30),
                                child: Text(
                                  translate('vehicle_management_page.please_select_status'),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                  ),
                                )),
                            SizedBox(
                                height: size.height - 380,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedStatus = 'Active';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Active',
                                        textColor: selectedStatus ==
                                            'Active'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedStatus ==
                                            'Active'
                                            ? '#5B78FA'
                                            : '#FFFFFF',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedStatus = 'Inactive';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Inactive',
                                        textColor: selectedStatus ==
                                            'Inactive'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedStatus ==
                                            'Inactive'
                                            ? '#5B78FA'
                                            : '#FFFFFF',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedStatus = 'Deactivated';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Deactivated',
                                        textColor: selectedStatus ==
                                            'Deactivated'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedStatus ==
                                            'Deactivated'
                                            ? '#5B78FA'
                                            : '#FFFFFF',
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('#5B78FA'),
                              padding: const EdgeInsets.all(15.5),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              if (selectedStatus.isNotEmpty) {

                                print(selectedStatus);
                                // getIt<SharedPreferenceHelper>().saveProvinces(selectedColor);
                                Navigator.of(context).pop(selectedStatus);

                              } else {
                                ShowSnackBar.showWithScaffold(
                                    _scaffoldKey, context, translate('select_something'),
                                    color: Colors.blueGrey.shade700);
                              }
                            },
                            child:  Text(
                              translate('choose'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
          )
      ),
    );
  }

}
