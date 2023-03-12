import 'package:fleetmanagement/bloc/mng/driver_management/assistant/list/assistant_bloc.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/driver/list/driver_bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/ui/vehicle/components/vehicle_menu.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/driver.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_assistant/driver_assistant.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../di/components/service_locator.dart';

class DriverManagement extends StatefulWidget {
  static const String route = '/driver_management';
  const DriverManagement({Key? key}) : super(key: key);

  @override
  _DriverManagementState createState() => _DriverManagementState();
}

class _DriverManagementState extends State<DriverManagement> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.driver_management'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              // BlocProvider.of<DriverBloc>(context).add(GetDriver());
              Navigator.pushNamed(context, Driver.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.driver'),
            ),
          ),
          InkWell(
            onTap: () {
              // BlocProvider.of<AssistantBloc>(context).add(GetAssistant());

              Navigator.pushNamed(context, DriverAssistant.route);
            },
            child: VehicleMenu(
              title: translate('vehicle_management_page.driver_assistant'),
            ),
          ),
        ],
      ),
    );
  }
}
