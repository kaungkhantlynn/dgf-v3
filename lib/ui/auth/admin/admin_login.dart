// ignore_for_file: unnecessary_new


import 'package:fleetmanagement/bloc/authentication/authentication_bloc.dart';
import 'package:fleetmanagement/bloc/login/bloc.dart';
import 'package:fleetmanagement/bloc/login/login_bloc.dart';
import 'package:fleetmanagement/data/auth_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'admin_sign_form.dart';
import 'frosted_glass_box.dart';

class AdminLogin extends StatefulWidget {
  static const String route = '/admin_login';

  const AdminLogin({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<AdminLogin> {
  bool isSwitched = false;

  final _formKey = GlobalKey<FormState>();

  late AuthenticationBloc? _authenticationBloc =
      AuthenticationBloc(getIt<AuthRepository>());
  LoginBloc? _loginBloc;
  AuthRepository authRepository = getIt<AuthRepository>();

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      authRepository: authRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width;
    return Scaffold(
        body: BlocProvider(
      create: (context) {
        return LoginBloc(
            authRepository: getIt<AuthRepository>(),
            authenticationBloc: _authenticationBloc);
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset('assets/original_bg.png').image,
                fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: FrostedGlassBox(
              child: Container(
                height: size.height,
                margin: const EdgeInsets.only(
                    left: 22, top: 80, right: 22, bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //upper column
                    const AdminSignForm(),

                    //bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Icon(
                        //   Icons.info,
                        //   color: Colors.white,
                        //   size: 50,
                        // ),
                        Container(
                          height: 50,
                          width: 132,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.all(2.4)),
                              Image.asset(
                                'assets/line.png',
                                width: 40,
                              ),
                              const Padding(padding: EdgeInsets.all(2.4)),
                              Text(
                                translate('line_chat'),
                                style: TextStyle(
                                    letterSpacing: 0.6,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
