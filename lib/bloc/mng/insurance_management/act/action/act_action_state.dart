import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:fleetmanagement/models/success_model.dart';

abstract class ActActionState {
  const ActActionState();
  @override
  List<Object> get props => [];
}

class ActActionInitial extends ActActionState {}

class ActActionLoading extends ActActionState {

  ActActionLoading();
}

class ActActionShowed extends ActActionState {
  ActData? actData;

  ActActionShowed(
      {this.actData});

  @override
  String toString() =>
      'ActActionShowed ';
}

class ActActionFinished extends ActActionState {
  SuccessModel? successModel;
  ActActionFinished(
      {this.successModel}
      );
}

class ActActionError extends ActActionState {
  final String? error;

  ActActionError({this.error});
}
