import 'package:fleetmanagement/bloc/jobfilter/jobfilter_bloc.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/driver/jobs/route_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../data/driver_repository.dart';
import 'jobs.dart';

class JobFilterResult extends StatefulWidget {

  String? date;


  JobFilterResult({Key? key,  this.date, })
      : super(key: key);
  @override
  _JobFilterResultState createState() => _JobFilterResultState();
}



class _JobFilterResultState extends State<JobFilterResult> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String selectedDate = "";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(create: (BuildContext context) {
      return JobFilterBloc(getIt<DriverRepository>());
    }, child: BlocBuilder<JobFilterBloc, JobFilterState>(builder: (context, state) {
      if (state is JobFilterInitial) {
        BlocProvider.of<JobFilterBloc>(context)
            .add(GetJobFilter(date: widget.date));
      }
      if (state is JobFilterLoaded) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 40),
          height: size.height - 130,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 1,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            translate('app_bar.filter_result'),
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w700,
                                fontSize: 19),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: size.height - 380,
                      child: state.routePlanData!.isNotEmpty ?  ListView.builder(
                          itemCount: state.routePlanData!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, RouteDetail.route,
                                    arguments: JobArguments(
                                        id: state
                                            .routePlanData![index]
                                            .id,
                                        routeName: state
                                            .routePlanData![index]
                                            .routeName));
                              },
                              child: routeContainer(
                                  time: state.routePlanData![index]
                                      .startTime ??
                                      '',
                                  routename: state
                                      .routePlanData![index]
                                      .routeName,
                                  license: state
                                      .routePlanData![index]
                                      .vehicleLicense,
                                  timeline: '${state
                                      .routePlanData![index]
                                      .startTime!} - ${state.routePlanData![index]
                                          .endTime!}',
                                  color: state.routePlanData![index].color!),
                            );
                          }) : const Center(
                        child: Text('There is no route'),
                      )
                  )
                ],
              ),

            ],
          ),
        );
      }
      if (state is JobFilterError) {
        return Container(
          child:  Center(
            child: Text(translate('no_route')),
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));


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
