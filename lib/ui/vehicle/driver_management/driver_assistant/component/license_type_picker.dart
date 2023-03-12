import 'package:fleetmanagement/bloc/mng/vehicle_management/config/config_bloc.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/widgets/language_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';

import '../../../../../data/network/api/mng/mng_api.dart';
import '../../../../widgets/appbar_page.dart';

class LicenseTypePicker extends StatefulWidget {

  LicenseTypePicker({Key? key})
      : super(key: key);

  @override
  _LicenseTypePickerState createState() => _LicenseTypePickerState();
}


class _LicenseTypePickerState extends State<LicenseTypePicker> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String selectedLicenseType = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppbarPage(
        title: 'License Type',
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
                                      'Select Vehicle License Type',
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
                                  'Please select the license type that you want to use',
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
                                          selectedLicenseType = 'Commercial';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Commercial',
                                        textColor: selectedLicenseType ==
                                           'Commercial'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedLicenseType ==
                                            'Commercial'
                                            ? '#5B78FA'
                                            : '#FFFFFF',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedLicenseType = 'Personal';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Personal',
                                        textColor: selectedLicenseType ==
                                           'Personal'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedLicenseType ==
                                            'Personal'
                                            ? '#5B78FA'
                                            : '#FFFFFF',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedLicenseType = 'Chauffeur';

                                        });

                                      },
                                      child: LanguageBtn(
                                        text: 'Chauffeur',
                                        textColor: selectedLicenseType ==
                                           'Chauffeur'
                                            ? '#FFFFFF'
                                            : '#373E48',
                                        bgColor: selectedLicenseType ==
                                            'Chauffeur'
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
                              if (selectedLicenseType.isNotEmpty) {

                                print(selectedLicenseType);
                                // getIt<SharedPreferenceHelper>().saveProvinces(selectedColor);
                                Navigator.of(context).pop(selectedLicenseType);

                              } else {
                                ShowSnackBar.showWithScaffold(
                                    _scaffoldKey, context, 'Select Something',
                                    color: Colors.blueGrey.shade700);
                              }
                            },
                            child: const Text(
                              'Choose',
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
