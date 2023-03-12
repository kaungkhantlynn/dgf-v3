import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_bloc.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_event.dart';
import 'package:fleetmanagement/data/auth_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';

import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepository;
  final AuthenticationBloc? authenticationBloc;

  LoginBloc({
    @required this.authRepository,
    @required this.authenticationBloc,
  })  : assert(authRepository != null),
        assert(authenticationBloc != null),
        super(LoginInitial());

  // LoginBloc(
  //     LoginState initialState, this.userRepository, this.authenticationBloc)
  //     : super(initialState);
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {

        bool isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          print('LOGINDATA ${event.loginData!.username}');
          final authModel = await authRepository?.authenticate(
            username: event.loginData!.username,
            password: event.loginData!.password,
          );

          authRepository!.saveRememberMe(event.loginData!);
          yield LoadingFinished();
          authenticationBloc!
              .add(LoggedIn(token: authModel!.token, isDriver: authModel.data!.isDriver));

          yield LoginInitial();
        }  else {
          yield LoginFailedInternetConnection();
        }


      } on UnauthorizedException catch (error) {
        yield LoginInitial();
        yield LoginFailure(error: error.message);
      } on NoInternetConnectionException catch (error) {
        yield LoginInitial();
        yield LoginFailure(error: error.message);
      } on BadRequestException catch (error ) {
        yield LoginFailure(error: error.message);
      }

      on InternalServerErrorException catch (error) {
        yield LoginInitial();
        yield LoginFailure(error: error.message);
      } catch (e) {
        yield LoginFailure(error: e.toString());
      }
    }
  }
}
