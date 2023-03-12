import 'package:fleetmanagement/ui/setting/components/setting_card.dart';
import 'package:fleetmanagement/ui/tracking/car_number_search.dart';
import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_management.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_management.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance_management.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_management.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/tracking_management.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_management.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class VehicleIndex extends StatefulWidget {
  const VehicleIndex({Key? key}) : super(key: key);

  @override
  _VehicleIndexState createState() => _VehicleIndexState();
}

class _VehicleIndexState extends State<VehicleIndex> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                translate('app_bar.vehicle_management'),
                style: TextStyle(color: Colors.grey.shade800),
              ),
            )),
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, TrackerManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.tracker_management'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, FuelManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.fuel_management'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, SensorManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.sensor_management'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, VehicleManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.vehicles_management'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, DriverManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.driver_management'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, InsuranceManagement.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.insurance_management'),
            ),
          ),
        ],
      ),
    );
  }
}
