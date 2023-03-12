import 'package:fleetmanagement/bloc/finished_job/finished_job_bloc.dart';
import 'package:fleetmanagement/ui/setting/components/finish_job_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../jobs/jobs.dart';
import '../jobs/route_detail.dart';

class FinishJobs extends StatefulWidget {
  const FinishJobs({Key? key}) : super(key: key);

  @override
  _FinishJobsState createState() => _FinishJobsState();
}

class _FinishJobsState extends State<FinishJobs> {
  late final RefreshController _refreshController = RefreshController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        isLeading : false,
        title: translate('app_bar.finished_job'),
      ),
      body: BlocListener<FinishedJobBloc,FinishedJobState>(
        listener: (context,state){
          if (state is FinishedJobLoading) {}
          if (state is FinishedJobLoaded) {
            _refreshController
              ..loadComplete()
              ..refreshCompleted();

          }
          if (state is FinishedJobError) {
            _refreshController
              ..loadFailed()
              ..refreshFailed();
          }
        },
        child:  BlocBuilder<FinishedJobBloc, FinishedJobState>(
            builder: (context, state) {
              if (state is FinishedJobLoaded) {
                if (state.success!) {
                  if (state.finishedJobDatas!.isNotEmpty) {
                    return SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      header: const WaterDropHeader(
                        waterDropColor: Colors.cyan,
                      ),
                      onRefresh: () async {
                        BlocProvider.of<FinishedJobBloc>(context)
                          ..add(ShowFinishedJobLoading())
                          ..add(GetFinishedJob());
                      },
                      onLoading: () async {
                        BlocProvider.of<FinishedJobBloc>(context)
                            .add(GetFinishedJob());
                      },
                      child:  ListView.builder(
                          itemCount: state.finishedJobDatas!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.pushNamed(
                                    context, RouteDetail.route,
                                    arguments: JobArguments(
                                        id: state.finishedJobDatas![index].id,
                                        routeName: state.finishedJobDatas![index].routeName));
                              },
                              child:  FinishJobCard(
                                title: state.finishedJobDatas![index].routeName,
                                info: state.finishedJobDatas![index].endDatetime,
                              ),
                            );
                          }),);
                  } else {
                    return  Center(
                      child: Text(
                        translate('there_is_no_finished_jobs'),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    );
                  }
                } else {
                  return  Center(
                    child: Text(
                      translate('there_is_no_finished_jobs'),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  );
                }
              }
              if (state is FinishedJobError) {
                print("FINISHED_JOB_ERROR");
                return Container(
                  child: Center(
                    child: Text(
                      state.error!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
