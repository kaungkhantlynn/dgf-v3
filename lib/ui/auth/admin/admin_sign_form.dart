import 'package:fleetmanagement/bloc/login/login_bloc.dart';
import 'package:fleetmanagement/bloc/login/login_event.dart';
import 'package:fleetmanagement/bloc/login/login_state.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/auth/login_data.dart';
import 'package:fleetmanagement/ui/widgets/language_selector.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminSignForm extends StatefulWidget {
  const AdminSignForm({
    Key? key,
  }) : super(key: key);

  @override
  AdminSignFormState createState() => AdminSignFormState();
}

class AdminSignFormState extends State<AdminSignForm> {
  bool isSwitched = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autoValidate = false;
  bool _isLoading = false;
  bool isKeyboardVisible = false;
  late FocusNode focusNode;

  KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();

  LoginData loginData =
      LoginData(username: "", password: "", rememberMe: false);

  // LoginBloc get _loginBloc => widget.loginBloc;

  @override
  void initState() {
    setState(() {
      focusNode = FocusNode();
      loginData.rememberMe = getIt<SharedPreferenceHelper>().getRememberMe();
      loginData.username = getIt<SharedPreferenceHelper>().getUsername();
      _emailController.text = loginData.username;
      loginData.password = getIt<SharedPreferenceHelper>().getPassword();
    });

    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width;

    void _onWidgetDidBuild(Function callback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        callback();
      });
    }

    _onAdminLoginButtonPress() async {
      FocusScope.of(context).unfocus();
      // focusNode.unfocus();

      if (_key.currentState!.validate()) {
        _key.currentState!.save();

        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(loginData: loginData),
        );
      }
      setState(() {
        _autoValidate = true;
      });
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ShowSnackBar.showWithScaffold(_scaffoldKey, context, state.error!,
              color: Colors.redAccent);
        }
        if (state is LoginLoading) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is LoadingFinished) {
          setState(() {
            _isLoading = false;
          });
        }
        if(state is LoginFailedInternetConnection){
          ShowSnackBar.showWithScaffold(_scaffoldKey, context,'No Internet Connection',
              color: Colors.redAccent);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            key: _key,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //nav
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade50),
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17)),
                                  elevation: 12,
                                  isDismissible: true,
                                  context: context,
                                  builder: (context) =>
                                      LanguageSelector(isPage: false));
                            },
                            child: const Text(
                              'Aa',
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.black87,
                                fontWeight: FontWeight.w900,
                              ),
                            ))),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(5.2)),
                Center(child: Image.asset('assets/login_logo.png')),
                const Padding(padding: EdgeInsets.all(14.4)),
                Center(
                  child: Text(
                    translate('welcome_text'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Kanit'),
                  ),
                ),

                const Padding(padding: EdgeInsets.all(20.6)),
                //username
                Container(
                  alignment: AlignmentDirectional.center,
                  height: 78,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius:
                              0, // has the effect of softening the shadow
                          offset: Offset(
                            0, // horizontal, move right 10
                            0, // vertical, move down 10
                          ),
                        ),
                      ]),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    enabled: true,
                    autofocus: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return translate('login.email_need_to_be_input');
                        // } else if (!EmailValidator.validate(value)) {
                        //   return "Please check your email";
                      }
                      return null;
                    },
                    obscureText: false,
                    decoration: inputDecoration(hintText: translate('login.email_hint')),
                    onSaved: (String? value) {
                      setState(() {
                        loginData.username = value ?? "";
                      });
                    },
                  ),
                ),

                //password
                Container(
                  alignment: AlignmentDirectional.center,
                  height: 78,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius:
                              0, // has the effect of softening the shadow
                          offset: Offset(
                            0, // horizontal, move right 10
                            0, // vertical, move down 10
                          ),
                        ),
                      ]),
                  child: TextFormField(
                    enabled: true,
                    autofocus: false,
                    controller: _passwordController,
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return  translate('login.password_need_to_be_input');
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: inputDecoration(hintText: translate('login.password_hint')),
                    onSaved: (String? value) {
                      setState(() {
                        loginData.password = value ?? "";
                      });
                    },
                  ),
                ),

                //remember_me
                const Padding(padding: EdgeInsets.all(15.2)),
                Wrap(
                  spacing: 2.2,
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            isSwitched = value;
                            loginData.rememberMe = value;
                          });
                        },
                        inactiveTrackColor: Colors.grey.shade300,
                        activeTrackColor: Colors.grey.shade300,
                        activeColor: Colors.grey.shade800,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 11.2, left: 5),
                      child: Text(
                        translate('login.remember_text'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),

                const Padding(padding: EdgeInsets.all(6)),

                FractionallySizedBox(
                  widthFactor: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor('#5A75FF'),
                      padding: const EdgeInsets.all(15.5),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      state is! LoginLoading
                          ? _onAdminLoginButtonPress()
                          : null;
                    },
                    child: Text(
                      translate('login.submit_text'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(14)),
                Container(
                  child: state is LoginLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : null,
                ),

                //Forgot_password
                const Padding(padding: EdgeInsets.all(14)),

              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration inputDecoration ({String? hintText}) {
    return InputDecoration(

        contentPadding:
        const EdgeInsets.only(left: 30, right: 30),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent, //this has no effect
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
            const BorderSide(color: Colors.transparent)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
            const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
            const BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
            const BorderSide(color: Colors.transparent)),
        hintText: translate(hintText!),
        errorStyle: const TextStyle(height: 1, fontSize: 15),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
            const BorderSide(color: Colors.transparent)),
        hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600));
  }
}
