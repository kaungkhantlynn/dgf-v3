import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/wsu.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class InsuranceManagement extends StatefulWidget {
  static const String route = '/insurance_management';
  const InsuranceManagement({Key? key}) : super(key: key);

  @override
  _InsuranceManagementState createState() => _InsuranceManagementState();
}

class _InsuranceManagementState extends State<InsuranceManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.insurance_management'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Wsu.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.wsu'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Insurance.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.insurance'),
            ),
          ),
        ],
      ),
    );
  }
}
