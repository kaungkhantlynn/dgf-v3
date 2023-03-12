import 'package:fleetmanagement/ui/tracking/carinfo/components/simple_info_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';

class JobDescription extends StatefulWidget {
  static const String route = '/job_description';
  const JobDescription({Key? key}) : super(key: key);

  @override
  _JobDescriptionState createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(title: 'Job Description'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.10)),
            SimpleInfoCard(primaryText: 'Name', secondaryText: 'Job title'),
            SimpleInfoCard(primaryText: 'Time', secondaryText: '13:00:00'),
            SimpleInfoCard(primaryText: 'Status', secondaryText: 'ACTIVE'),
            SimpleInfoCard(primaryText: 'Vehicle', secondaryText: 'H1-7'),
            SimpleInfoCard(primaryText: 'Driver', secondaryText: 'Pum'),
            const Padding(padding: EdgeInsets.all(10.10)),
            SimpleInfoCard(
                primaryText: 'Registration date', secondaryText: '2021/10/05'),
            SimpleInfoCard(
                primaryText: 'Destination',
                secondaryText: 'ทางหลวงชนบทหมายเลข 7043'),
            SimpleInfoCard(primaryText: 'Note', secondaryText: '-')
          ],
        ),
      )),
    );
  }
}
