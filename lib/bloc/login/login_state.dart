import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginFailedInternetConnection extends LoginState {}
class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoadingFinished extends LoginState {}

class LoginFailure extends LoginState {
  final String? error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error!];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
