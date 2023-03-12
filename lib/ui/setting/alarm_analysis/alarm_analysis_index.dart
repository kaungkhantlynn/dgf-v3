import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';

class AlarmAnalysisIndex extends StatefulWidget {
  static const String route = '/alarm_analysis_index';
  const AlarmAnalysisIndex({Key? key}) : super(key: key);

  @override
  _AlarmAnalysisIndexState createState() => _AlarmAnalysisIndexState();
}

class _AlarmAnalysisIndexState extends State<AlarmAnalysisIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: 'Alarm Analysis',
      ),
      body: SafeArea(child: Container()),
    );
  }
}
