import 'package:fleetmanagement/models/jsession_model.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';

abstract class JsessionState {}

class JsessionInitial extends JsessionState {}

class JsessionCompleted extends JsessionState {
  final JsessionModel jsessionModel;

  JsessionCompleted(this.jsessionModel);
}

class JsessionError extends JsessionState {
  final String message;

  JsessionError(this.message);
}
