import 'package:fleetmanagement/bloc/authentication/authentication_bloc.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_event.dart';
import 'package:fleetmanagement/ui/driver/setting/components/driver_profile.dart';
import 'package:fleetmanagement/ui/setting/components/setting_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DriverSetting extends StatefulWidget {
  const DriverSetting({Key? key}) : super(key: key);

  @override
  _DriverSettingState createState() => _DriverSettingState();
}

class _DriverSettingState extends State<DriverSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage(
        isLeading: false,
        title: translate('app_bar.setting'),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16.5)),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, DriverProfile.route);
            },
            child: SettingCard(
              title: translate('driver.user'),
              color: '#707070',
              iconData: Icons.account_circle,
              isInfoExit: false,
              info: '',
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            child: SettingCard(
              title: translate('sign_out'),
              color: '#FF7C7C',
              iconData: Icons.logout,
              isInfoExit: false,
              info: '',
            ),
          )
        ],
      ),
    );
  }
}
