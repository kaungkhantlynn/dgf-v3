import 'package:fleetmanagement/bloc/routeplan/route_plan_bloc.dart';
import 'package:fleetmanagement/ui/driver/jobs/job_filter.dart';
import 'package:fleetmanagement/ui/driver/jobs/route_detail.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets/snackbar.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class JobArguments {
  int? id;
  String? routeName;
  JobArguments({this.id, this.routeName});
}

class _JobsState extends State<Jobs> {
  late final RefreshController _refreshController = RefreshController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.jobs'),
          isLeading: false,
        ),
        body:BlocListener<RoutePlanBloc, RoutePlanState>(
          listener: (context, state) {
            if (state is RoutePlanLoading) {}
            if (state is RoutePlanLoaded) {
              _refreshController
                ..loadComplete()
                ..refreshCompleted();

            }
            if (state is RoutePlanError) {
              _refreshController
                ..loadFailed()
                ..refreshFailed();
            }
            // if (state is FailedInternetConnection) {
            //   ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
            //       color: Colors.redAccent);
            // }
          },
    child: BlocBuilder<RoutePlanBloc, RoutePlanState>(
          builder: (context, state) {
            if (state is RoutePlanLoaded) {
              if (state.success!) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 17, top: 26),
                          child: Text(
                            translate('driver.today'),
                            style: const TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                          ),

                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 17, top: 26),
                          child: IconButton(icon: Icon(Icons.refresh,color: Colors.blue.shade700,), onPressed: () {
                            BlocProvider.of<RoutePlanBloc>(context)
                              ..add(ShowRoutePlanLoading())
                              ..add(GetRoutePlan());
                          },))
                      ],
                    ),
                    Expanded(
                      child: Container(
                          width: mediaQuery.size.width,
                          margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(13.5),
                                  topRight: Radius.circular(13.5)),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    offset: const Offset(0, 1),
                                    blurRadius: 1.5,
                                    spreadRadius: 0)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   margin: EdgeInsets.only(left: 10, top: 11),
                              //   child: Text(
                              //     'วันจันทร์ที่ 10 ต.ค. 2564',
                              //     style: TextStyle(
                              //         fontSize: 16, fontFamily: 'Kanit'),
                              //   ),
                              // ),

                              state.routePlanDatas!.isNotEmpty ?
                              Expanded(
                                  child: SmartRefresher(
                                      controller: _refreshController,
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      header: const WaterDropHeader(
                                        waterDropColor: Colors.cyan,
                                      ),
                                      onRefresh: () async {
                                        BlocProvider.of<RoutePlanBloc>(context)
                                          ..add(ShowRoutePlanLoading())
                                          ..add(GetRoutePlan());
                                      },
                                      onLoading: () async {
                                        BlocProvider.of<RoutePlanBloc>(context)
                                            .add(GetRoutePlan());
                                      },
                                    child : ListView.builder(

                                        itemCount: state.routePlanDatas!.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              var data=  Navigator.pushNamed(
                                                  context, RouteDetail.route,
                                                  arguments: JobArguments(
                                                      id: state
                                                          .routePlanDatas![index]
                                                          .id,
                                                      routeName: state
                                                          .routePlanDatas![index]
                                                          .routeName));

                                            },
                                            child: routeContainer(
                                                time: state.routePlanDatas![index]
                                                    .startTime ??
                                                    '',
                                                routename: state
                                                    .routePlanDatas![index]
                                                    .routeName,
                                                license: state
                                                    .routePlanDatas![index]
                                                    .vehicleLicense,
                                                timeline: '${state
                                                    .routePlanDatas![index]
                                                    .startTime!} - ${state.routePlanDatas![index]
                                                    .endTime!}',
                                                color: state.routePlanDatas![index].color!),
                                          );
                                        })
                                  )

                              ) :
                                  Expanded(child: Center(
                                    child: Text(translate('no_route_plan')),
                                  ))
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        // Flushbar(
                        //   title: "Comming Soon ",
                        //   message: "This feature will be able in Phase 3",
                        //   duration: Duration(seconds: 3),
                        // )..show(context);
                        Navigator.pushNamed(context,JobFilter.route);
                      },
                      child: Container(
                        width: mediaQuery.size.width,
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        padding: const EdgeInsets.all(7.7),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(13.5),
                                bottomRight: Radius.circular(13.5)),
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1.5,
                                  spreadRadius: 0)
                            ]),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.qr_code_sharp,
                                color: Colors.grey.shade800,
                              ),
                               Text(
                                translate('search'),
                                style: TextStyle(
                                    fontFamily: 'Kanit', fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(44.44))
                  ],
                );
              } else {
                return  Center(
                  child: Text(
                    translate('there_is_no_data'),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                    ),
                  ),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    ));
  }

  Container routeContainer(
      {String? time,
      String? timeline,
      String? routename,
      String? license,
      String? color}) {
    return Container(
        margin: const EdgeInsets.only(left: 10, top: 14),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time!,
              style: const TextStyle(fontSize: 18, fontFamily: 'Kanit'),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
              padding: const EdgeInsets.all(8.8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                shape: BoxShape.rectangle,
                color: HexColor(color!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.4),
                        child: Text(
                          routename!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Kanit'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.4),
                        child: Text(
                          license!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Kanit'),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.4),
                    child: Text(
                      timeline!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Kanit'),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ));
  }
}
