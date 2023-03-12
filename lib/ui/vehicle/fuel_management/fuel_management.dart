import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/consumption_rate.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/fuel_type.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FuelManagement extends StatefulWidget {
  static const String route = '/fuel_management';
  const FuelManagement({Key? key}) : super(key: key);

  @override
  _FuelManagementState createState() => _FuelManagementState();
}

class _FuelManagementState extends State<FuelManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.fuel_management'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, FuelType.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.fuel_type'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ConsumptionRate.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.consumption_rate'),
            ),
          ),
        ],
      ),
    );
  }
}
