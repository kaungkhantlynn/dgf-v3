import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class InsuranceActionState {
  const InsuranceActionState();
  @override
  List<Object> get props => [];
}

class InsuranceActionInitial extends InsuranceActionState {}

class InsuranceActionLoading extends InsuranceActionState {

  InsuranceActionLoading();
}

class InsuranceActionShowed extends InsuranceActionState {
  InsuranceData? insuranceData;

  InsuranceActionShowed(
      {this.insuranceData});

  @override
  String toString() =>
      'InsuranceActionShowed ';
}

class InsuranceActionFinished extends InsuranceActionState {
  SuccessModel? successModel;
  InsuranceActionFinished(
      {this.successModel}
      );
}

class InsuranceActionError extends InsuranceActionState {
  final String? error;

  InsuranceActionError({this.error});
}
