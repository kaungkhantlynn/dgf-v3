import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class FirstTimeUse extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AdminAuthenticationAuthenticated extends AuthenticationState {}

class DriverAuthenticationAuthenticated extends AuthenticationState {}

class FirstTimeFailure extends AuthenticationState {
  final String? error;

  FirstTimeFailure({@required this.error});

  @override
  List<Object> get props => [error!];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
