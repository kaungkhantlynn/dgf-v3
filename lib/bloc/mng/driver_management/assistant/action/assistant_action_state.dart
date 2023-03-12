import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AssistantActionState {
  const AssistantActionState();
  @override
  List<Object> get props => [];
}

class AssistantActionInitial extends AssistantActionState {}

class AssistantActionLoading extends AssistantActionState {

  AssistantActionLoading();
}

class AssistantActionShowed extends AssistantActionState {
  AssistantData? assistantData;

  AssistantActionShowed(
      {this.assistantData});

  @override
  String toString() =>
      'AssistantActionShowed ';
}

class AssistantActionFinished extends AssistantActionState {
  SuccessModel? successModel;
  AssistantActionFinished(
      {this.successModel}
      );
}

class AssistantActionError extends AssistantActionState {
  final String? error;

  AssistantActionError({this.error});
}
