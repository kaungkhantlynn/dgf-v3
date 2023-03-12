import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/auth_repository.dart';
import 'package:fleetmanagement/data/sharedpref/constants/preferences.dart';
import 'package:fleetmanagement/models/auth/auth_check_model.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late AuthRepository authRepository;

  // constructor:---------------------------------------------------------------
  // AuthenticationBloc() : super(AuthenticationUninitialized());

  AuthenticationBloc(this.authRepository)
      : super(AuthenticationUnauthenticated());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield AuthenticationLoading();
      try {
        AuthCheckModel authCheckModel = await authRepository.checkAuth();
        if (authCheckModel.success!) {
          print("MYAPPSTART");
          //from share prefs
          final String? tokenKey = await authRepository.getToken();
          // print("LOGINNED TOKEN" + tokenKey!);
          yield AuthenticationLoading();
          await Future.delayed(const Duration(seconds: 1));
          if (tokenKey == null) {
            print("MUNAUTH");
            yield AuthenticationUnauthenticated();
          } else if (tokenKey == Preferences.logoutString) {
            print("MUNAUTH_UNIAUTH");
            yield AuthenticationUnauthenticated();
          } else if (tokenKey != Preferences.logoutString &&
              tokenKey.length > 20) {
            print(tokenKey);
            print(Preferences.logoutString);
            print("Authed");
            if (authCheckModel.isDriver!) {
              yield DriverAuthenticationAuthenticated();
            } else {
              yield AdminAuthenticationAuthenticated();
            }
          }
        } else {
          yield AuthenticationLoading();
          await authRepository.expiredToken();

          yield AuthenticationUnauthenticated();
        }
      } catch (error) {
        {
          yield AuthenticationLoading();
          await authRepository.expiredToken();
          yield AuthenticationUnauthenticated();
        }
      }
    }

    // if (event is DoFirstTime) {
    //   await authRepository.doFirstTime();
    //   yield AuthenticationUnauthenticated();
    // }

    if (event is LoggedIn) {
      print("TOKEN_LOGGEDIN${event.token!}");
      yield AuthenticationLoading();
      await authRepository.persistToken(event.token!);

      Preferences.authKey = (await authRepository.getToken())!;
      print("LOGIN_KEY ${Preferences.authKey}");
      // await Future.delayed(const Duration(seconds: 2));
      if (event.isDriver!) {
        yield DriverAuthenticationAuthenticated();
      } else {
        yield AdminAuthenticationAuthenticated();
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();

      await authRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
