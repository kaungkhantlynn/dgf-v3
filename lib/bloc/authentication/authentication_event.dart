import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class DoFirstTime extends AuthenticationEvent {
  final String? dofirstTime;

  const DoFirstTime({@required this.dofirstTime});

  @override
  List<Object> get props => [dofirstTime!];

  @override
  String toString() => 'DidFirstTime { token: $dofirstTime }';
}

class LoggedIn extends AuthenticationEvent {
  final String? token;
  final bool? isDriver;
  const LoggedIn({@required this.token, this.isDriver});

  @override
  List<Object> get props => [token!];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoggedOut extends AuthenticationEvent {}
