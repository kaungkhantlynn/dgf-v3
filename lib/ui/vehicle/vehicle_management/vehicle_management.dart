import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class VehicleManagement extends StatefulWidget {
  static const String route = '/vehicle_management';
  const VehicleManagement({Key? key}) : super(key: key);

  @override
  _VehicleManagementState createState() => _VehicleManagementState();
}

class _VehicleManagementState extends State<VehicleManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.vehicle_management'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, VehicleType.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.vehicle_type'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Vehicle.route);
            },
            child: VehicleMenu(
              title: translate("vehicle_management_page.vehicle"),
            ),
          ),
        ],
      ),
    );
  }
}
