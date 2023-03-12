import 'package:fleetmanagement/bloc/notification/notification_bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../di/components/service_locator.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.notifications'),
        isLeading: false,
      ),
      body: BlocBuilder<NotificationBloc,NotificationState>(
        builder: (context,state){
          if (state is InitialNotificationState) {
            BlocProvider.of<NotificationBloc>(context)
                .add(GetNotification());
          }
          if (state is NotificationLoaded){
            return state.notifications!.isNotEmpty ?
            ListView.builder(
                itemCount: state.notifications!.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20.3),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: HexColor('#C8C7CC'),width: 1))
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(translate('driver.new_assignment'),style: TextStyle(color: HexColor('#373E48'),fontSize: 16),),
                            Icon(Icons.keyboard_arrow_right_sharp,color: HexColor('#373E48'),)
                          ],
                        ),
                        const SizedBox(height: 4.4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4.5),
                                child:Text(translate('driver.route'),style: TextStyle(color: HexColor('#20242A'),fontSize: 16),)) ,
                            Text('${state.notifications![index].name}',style: TextStyle(color: HexColor('#949397'),fontSize: 16),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4.5),
                                child:Text(translate('driver.vehicle'),style: TextStyle(color: HexColor('#20242A'),fontSize: 16),)) ,
                            Text('${state.notifications![index].license}',style: TextStyle(color: HexColor('#949397'),fontSize: 16),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4.5),
                                child:Text(translate('driver.start_time'),style: TextStyle(color: HexColor('#20242A'),fontSize: 16),)) ,
                            Text('${state.notifications![index].startTime}',style: TextStyle(color: HexColor('#949397'),fontSize: 16),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4.5),
                                child:Text(translate('driver.end_time'),style: TextStyle(color: HexColor('#20242A'),fontSize: 16),)) ,
                            Text('${state.notifications![index].endTime}',style: TextStyle(color: HexColor('#949397'),fontSize: 16),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4.5),
                                child:Text(translate('driver.vehicle'),style: TextStyle(color: HexColor('#20242A'),fontSize: 16),)) ,
                            Text('NPR01',style: TextStyle(color: HexColor('#949397'),fontSize: 16),),
                          ],
                        ),

                      ],
                    ),
                  );
                }): Container(child:  Center(child: Text(translate('there_is_no_data')),),);
          }
          return Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
