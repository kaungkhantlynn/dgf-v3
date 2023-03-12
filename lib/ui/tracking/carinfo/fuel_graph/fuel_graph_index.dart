import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';

class FuelGraphIndex extends StatefulWidget {
  static const String route = '/fuel_graph_index';
  const FuelGraphIndex({Key? key}) : super(key: key);

  @override
  _FuelGraphIndexState createState() => _FuelGraphIndexState();
}

class _FuelGraphIndexState extends State<FuelGraphIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        title: 'Fuel Usae Graph',
      ),
      body: SafeArea(child: Container()),
    );
  }
}
