import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/report_count.dart';
import 'package:fleetmanagement/ui/overspeed/over_speed_index.dart';
import 'package:fleetmanagement/ui/parking/parking_index.dart';
import 'package:fleetmanagement/ui/setting/setting_index.dart';
import 'package:fleetmanagement/ui/tracking/tracking_index.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_index.dart';
import 'package:fleetmanagement/ui/widgets/sphere_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customicon/custom_icon_font.dart';
import '../../data/network/dio_client.dart';
import '../../data/network/rest_client.dart';

class HomeIndex extends StatefulWidget {
  static const String route = '/home_index';
  const HomeIndex({Key? key}) : super(key: key);

  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  Color backgroudColor = Colors.white;
  int _selectedIndex = 0;

  String? parkingCount;
  String? overSpeedCount;
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper(getIt<SharedPreferences>());
  static const List<Widget> _pages = <Widget>[
    TrackingIndex(),
    // ClusterPointsView(),
    ParkingIndex(),
    OverspeedIndex(),
    VehicleIndex(),
    SettingIndex()
  ];


  @override
  void initState() {
    getNotiCount();
  }

  void getNotiCount()async{
    OtherApi otherApi = OtherApi(getIt<DioClient>(), getIt<RestClient>());

    ReportCount parking =await otherApi.getReportCount('parking');
    ReportCount overSpeed =await otherApi.getReportCount('overspeed');

    print("${parking.count} PKCOUNT");
    print("${overSpeed.count} OVCOUNT");
    // if (parking.count!  < 10000) {
    //
    // }  else {
    //   sharedPreferenceHelper.saveParkingCount('9999+');
    // }
    sharedPreferenceHelper.saveParkingCount(parking.count.toString());
    sharedPreferenceHelper.saveOverspeedCount(overSpeed.count.toString());
    // if (overSpeed.count!  < 10000) {
    //
    // }  else {
    //   sharedPreferenceHelper.saveOverspeedCount('9999+');
    // }

  }

  @override
  Widget build(BuildContext context) {
   getNotiCount();

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: SphereBottomNavigationBar(
          defaultSelectedItem: _selectedIndex,
          sheetRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          onItemPressed: (index) => setState(() {
            print('Selected item is - $index');
            switch (index) {
              case 0:
                backgroudColor = const Color(0xFFFFD6B2);
                _selectedIndex = index;
                break;
              case 1:
                backgroudColor = const Color(0xFFB2F4FF);
                _selectedIndex = index;
                break;
              case 2:
                backgroudColor = const Color(0xFFCDB2FF);
                _selectedIndex = index;
                break;
              case 3:
                backgroudColor = const Color(0xFFFFB2D9);
                _selectedIndex = index;
                break;
              case 4:
                backgroudColor = const Color(0xFFFFB2D9);
                _selectedIndex = index;
                break;
              default:
            }
          }),
          onItemLongPressed: (index) => setState(() {
            backgroudColor = const Color(0xFF44D6B2);
          }),
          sheetBackgroundColor: Colors.white,
          navigationItems: [
            BuildNavigationItem(
                // tooltip: 'Map Tracking',
                itemColor: Colors.grey.shade400,
                icon: const Icon(
                  LineIcons.map,
                  size: 30,
                ),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: false,
                notiCount: '0'),
        BuildNavigationItem(
            tooltip: 'Parking Report',
            itemColor: Colors.grey.shade400,
            icon:
            const Icon(CustomFontIcons.customparkingoutlined, size: 28),
            selectedItemColor: Colors.blue.shade600,
            title: '',
            hasNoti: true,
            notiCount: sharedPreferenceHelper.getParkingCount()
        ),
            // BlocBuilder<ReportCountCubit,ReportCountState>(
            //   builder: (context,state){
            //     if (state is ReportCountInitial) {
            //       context.read<ReportCountCubit>().reportCount('parking');
            //     }
            //     if (state is ReportCountLoaded) {
            //
            //       BuildNavigationItem(
            //           tooltip: 'Parking Report',
            //           itemColor: Colors.grey.shade400,
            //           icon:
            //           const Icon(CustomFontIcons.customparkingoutlined, size: 28),
            //           selectedItemColor: Colors.blue.shade600,
            //           title: '',
            //           hasNoti: true,
            //           notiCount: state.deviceData!.count.toString()
            //       );
            //     }
            //     return Container();
            //   }
            // ),
      BuildNavigationItem(
          tooltip: 'Overspeed Report',
          itemColor: Colors.grey.shade400,
          icon:
          const Icon(LineAwesomeIcons.alternate_tachometer, size: 28),
          selectedItemColor: Colors.blue.shade600,
          title: '',
          hasNoti: true,
          notiCount: sharedPreferenceHelper.getOverspeedCount()
      ),
            // BlocBuilder<ReportCountCubit,ReportCountState>(
            //     builder: (context,state){
            //       if (state is ReportCountInitial) {
            //         context.read<ReportCountCubit>().reportCount('overspeed');
            //       }
            //       if (state is ReportCountLoaded) {
            //
            //         BuildNavigationItem(
            //             tooltip: 'Overspeed Report',
            //             itemColor: Colors.grey.shade400,
            //             icon:
            //             const Icon(CustomFontIcons.customparkingoutlined, size: 28),
            //             selectedItemColor: Colors.blue.shade600,
            //             title: '',
            //             hasNoti: true,
            //             notiCount: state.deviceData!.count.toString()
            //         );
            //       }
            //       return Container();
            //     }
            // ),


            BuildNavigationItem(
                icon: const Icon(
                  LineAwesomeIcons.truck,
                  size: 30,
                ),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: false,
                notiCount:'0' ),
            BuildNavigationItem(
                tooltip: '',
                itemColor: Colors.grey.shade400,
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: false,
                notiCount: '0'),
          ],
        ),
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        )
    );
  }
}
