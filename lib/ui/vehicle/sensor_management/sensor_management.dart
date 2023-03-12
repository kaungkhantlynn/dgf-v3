import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/sensor_type.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SensorManagement extends StatefulWidget {
  static const String route = '/sensor_management';
  const SensorManagement({Key? key}) : super(key: key);

  @override
  _SensorManagementState createState() => _SensorManagementState();
}

class _SensorManagementState extends State<SensorManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.sensor_management'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, SensorType.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.sensor_type'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Sensor.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.sensor'),
            ),
          ),
        ],
      ),
    );
  }
}
