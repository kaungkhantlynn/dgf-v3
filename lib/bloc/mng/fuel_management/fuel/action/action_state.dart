import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/success_model.dart';

abstract class ActionState {
  const ActionState();
  @override
  List<Object> get props => [];
}

class ActionInitial extends ActionState {}

class ActionLoading extends ActionState {

  ActionLoading();
}

class ActionShowed extends ActionState {
  FuelData? fuelData;

  ActionShowed(
      {this.fuelData});

  @override
  String toString() =>
      'ActionShowed ';
}

class ActionFinished extends ActionState {
  SuccessModel? successModel;
  ActionFinished(
  {this.successModel}
      );
}

class ActionError extends ActionState {
  final String? error;

  ActionError({this.error});
}
