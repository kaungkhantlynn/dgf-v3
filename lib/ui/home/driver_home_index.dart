import 'package:fleetmanagement/ui/driver/finish_jobs/finish_jobs.dart';
import 'package:fleetmanagement/ui/driver/jobs/jobs.dart';
import 'package:fleetmanagement/ui/driver/notification/notifications.dart';
import 'package:fleetmanagement/ui/driver/setting/driver_setting.dart';
import 'package:fleetmanagement/ui/widgets/sphere_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/finished_job/finished_job_bloc.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/routeplan/route_plan_bloc.dart';
import '../../bloc/save_finished_job/save_finish_job_bloc.dart';
import '../../data/driver_repository.dart';
import '../../data/network/api/other/other_api.dart';
import '../../data/network/dio_client.dart';
import '../../data/network/rest_client.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../models/noti_count.dart';

class DriverHomeIndex extends StatefulWidget {
  static const String route = '/driver_home_index';
  const DriverHomeIndex({Key? key}) : super(key: key);

  @override
  _DriverHomeIndexState createState() => _DriverHomeIndexState();
}

class _DriverHomeIndexState extends State<DriverHomeIndex> {
  Color backgroudColor = Colors.white;
  int _selectedIndex = 0;

  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper(getIt<SharedPreferences>());
  @override
  void initState() {
    getNotiCount();
  }

  void getNotiCount()async{
    OtherApi otherApi = OtherApi(getIt<DioClient>(), getIt<RestClient>());

    NotiCount notiCount =await otherApi.getDriverNotiCount();

    print("${notiCount.data!.count} NOTICOUNT");

    // if (parking.count!  < 10000) {
    //
    // }  else {
    //   sharedPreferenceHelper.saveParkingCount('9999+');
    // }
    sharedPreferenceHelper.saveNotiCount(notiCount.data!.count.toString());
    // if (overSpeed.count!  < 10000) {
    //
    // }  else {
    //   sharedPreferenceHelper.saveOverspeedCount('9999+');
    // }

  }

  static const List<Widget> _pages = <Widget>[
    Jobs(),
    // ClusterPointsView(),
    FinishJobs(),
    Notifications(),
    DriverSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<RoutePlanBloc>(create: (context) {
          return RoutePlanBloc(getIt<DriverRepository>())
            ..add(const GetRoutePlan());
        }),
        BlocProvider<NotificationBloc>(create: (context) {
          return NotificationBloc(getIt<DriverRepository>())
            ..add(GetNotification());
        }),
        BlocProvider<SaveFinishJobBloc>(create: (context) {
          return SaveFinishJobBloc(getIt<DriverRepository>());
        }),
        BlocProvider<FinishedJobBloc>(create: (context) {
          return FinishedJobBloc(getIt<DriverRepository>())
            ..add(const GetFinishedJob());
        }),

      ],
      child:Scaffold(
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
                  tooltip: 'Route List',
                  itemColor: Colors.grey.shade400,
                  icon: const Icon(
                    Icons.list_sharp,
                    size: 30,
                  ),
                  selectedItemColor: Colors.blue.shade600,
                  hasNoti: false,
                  notiCount: '0',
                  title: ''),
              BuildNavigationItem(
                tooltip: 'Finished Job',
                itemColor: Colors.grey.shade400,
                icon: const Icon(Icons.check, size: 28),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: false,
                notiCount: '0',
              ),
              BuildNavigationItem(
                tooltip: 'Notification',
                itemColor: Colors.grey.shade400,
                icon: const Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: true,
                notiCount: sharedPreferenceHelper.getNotiCount(),
              ),
              BuildNavigationItem(
                tooltip: 'Setting',
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                selectedItemColor: Colors.blue.shade600,
                title: '',
                hasNoti: false,
                notiCount: '0',
              ),
            ],
          ),
          body: Center(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ))
    );
  }
}
