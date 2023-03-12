import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';

class MileageAnalytics extends StatefulWidget {
  static const String route = '/milage_analytics';
  const MileageAnalytics({Key? key}) : super(key: key);

  @override
  _MileageAnalyticsState createState() => _MileageAnalyticsState();
}

class _MileageAnalyticsState extends State<MileageAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: 'Mileage Analytics',
      ),
    );
  }
}
