import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'components/simple_info_card.dart';

class RouteDescription extends StatefulWidget {
  static const String route = '/route_description';
  const RouteDescription({Key? key}) : super(key: key);

  @override
  _RouteDescriptionState createState() => _RouteDescriptionState();
}

class _RouteDescriptionState extends State<RouteDescription> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RouteDesArguments;
    return Scaffold(
      appBar: AppbarPage(title: translate('app_bar.route_description')),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.10)),
            SimpleInfoCard(primaryText: translate('route_description_page.name'), secondaryText: args.name!),
            SimpleInfoCard(
                primaryText: translate('route_description_page.vehicle'), secondaryText: args.vehicle!),
            SimpleInfoCard(
                primaryText: translate('route_description_page.driver'), secondaryText: args.drivername!),
            const Padding(padding: EdgeInsets.all(10.10)),
            SimpleInfoCard(
                primaryText: translate('route_description_page.estimated_total_distance'),
                secondaryText: args.estimatedTotalDistance! + 'km'),
            SimpleInfoCard(
                primaryText: translate('route_description_page.estimated_total_duration'),
                secondaryText: args.estimatedTotalDuration!),
            SimpleInfoCard(
                primaryText: translate('route_description_page.actual_total_distance'),
                secondaryText: args.acturalTotalDistance! + 'km'),
            SimpleInfoCard (
                primaryText: translate('route_description_page.actual_total_duration'),
                secondaryText: args.acturalTotalDuration!),
          ],
        ),
      )),
    );
  }
}
