import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:fleetmanagement/bloc/device_status/device_cubit.dart';
import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/models/device_status.dart';
import 'package:fleetmanagement/models/device_status_column_request.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:high_chart/high_chart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../di/components/service_locator.dart';
import '../../../models/device_status_pie_request.dart';

class DeviceStatusIndex extends StatefulWidget {
  static const String route = '/device_status_index';
  const DeviceStatusIndex({Key? key}) : super(key: key);

  @override
  _DeviceStatusIndexState createState() => _DeviceStatusIndexState();
}

class _DeviceStatusIndexState extends State<DeviceStatusIndex> {
  int touchedIndex = -1;
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedBarIndex = -1;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DeviceCubit(getIt<OtherApi>()))
        ],
        child: Scaffold(
          appBar: AppbarPage(
            title: translate('app_bar.device_status'),
          ),
          body: const SafeArea(
            child: SingleChildScrollView(
              child: DgfHighChart(),
            )
          ),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 130.0 : 120.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: HexColor('#222831'),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: HexColor('#00C6BF'),
            value: 65,
            title: '85%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}

class DgfHighChart extends StatelessWidget {
  const DgfHighChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = BlocProvider.of<DeviceCubit>(context);
    device.loadChart();
    return BlocBuilder<DeviceCubit, DeviceState>(
      builder: (context, state) {
        if (state is DeviceStateLoaded) {
          PieTitle title = PieTitle(text: state.deviceData![0].title);
          List<PieSeries> pieSeries = [
            PieSeries(
                type: 'pie',
                name: 'Device Status',
                data: state.deviceData![0].legends,
                center: [180, 130],
                size: 300,
                showInLegend: true,
                dataLabels: PieDataLabels(enabled: true))
          ];
          DeviceStatusPieRequest deviceStatusPieRequest =
              DeviceStatusPieRequest(title: title, series: pieSeries);
          String pieData = json.encode(deviceStatusPieRequest);

          ColumnTitle columnTitle = ColumnTitle(text: state.deviceData![1].title);
          List<Legends> columnSeries = state.deviceData![1].legends!;

          DeviceStatusColumnRequest deviceStatusColumnRequest = DeviceStatusColumnRequest(
            title: columnTitle,
            series: columnSeries
          );

          String columnData = json.encode(deviceStatusColumnRequest);

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HighCharts(

                size:   Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/ 2.4),
                data: pieData,
                scripts: const [
                  "https://code.highcharts.com/highcharts.js",
                  'https://code.highcharts.com/modules/networkgraph.js',
                  'https://code.highcharts.com/modules/exporting.js',
                ],
              ),
              HighCharts(

                size:   Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/ 2.4),
                data: columnData,
                scripts: const [
                  "https://code.highcharts.com/highcharts.js",
                  'https://code.highcharts.com/modules/networkgraph.js',
                  'https://code.highcharts.com/modules/exporting.js',
                ],
              )
            ],
          );
        }
        return const Center(
          child: LinearProgressIndicator()
        );
      },
    );
  }
}
