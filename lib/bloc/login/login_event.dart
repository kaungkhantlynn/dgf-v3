import 'package:fleetmanagement/models/auth/login_data.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  LoginData? loginData;

  LoginButtonPressed({
    this.loginData,
  });

  @override
  List<Object> get props => [loginData!];

  @override
  String toString() => 'LoginButtonPressed { loginData:$loginData }';
}
