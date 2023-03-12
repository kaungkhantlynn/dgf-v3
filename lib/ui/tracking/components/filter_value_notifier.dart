import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';
import 'package:flutter/widgets.dart';

class FilterValueNotifier extends ValueNotifier<List<VehicleSummaryData>> {
  FilterValueNotifier({List<VehicleSummaryData>? value}) : super(value!);
}
