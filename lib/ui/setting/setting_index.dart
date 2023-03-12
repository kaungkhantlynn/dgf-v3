import 'package:fleetmanagement/bloc/authentication/bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/ui/setting/components/setting_card.dart';
import 'package:fleetmanagement/ui/setting/contact/contact.dart';
import 'package:fleetmanagement/ui/setting/device_status/device_status_index.dart';
import 'package:fleetmanagement/ui/setting/language/select_language.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:line_icons/line_icons.dart';

class SettingIndex extends StatefulWidget {
  const SettingIndex({Key? key}) : super(key: key);

  @override
  _SettingIndexState createState() => _SettingIndexState();
}

class _SettingIndexState extends State<SettingIndex> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          title: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  translate('app_bar.setting'),
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              )),
          iconTheme: const IconThemeData(color: Colors.black87),
          // actions: <Widget>[
          //   IconButton(
          //     onPressed: () {
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => FilterSearch()));
          //     },
          //     icon: const Icon(
          //       Icons.search_rounded,
          //       color: Colors.black,
          //       size: 28,
          //     ),
          //   ),
          // ],
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: ListView(children: [
            const Padding(padding: EdgeInsets.all(10.10)),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, DeviceStatusIndex.route);
              },
              child: SettingCard(
                title: translate('setting_page.device_status'),
                color: '#00C6BF',
                iconData: LineIcons.pieChart,
                isInfoExit: false,
                info: '',
              ),
            ),
            InkWell(
              onTap: () {
                ShowSnackBar.showWithScaffold(
                    _scaffoldKey, context, Strings.commingSoon,
                    color: Colors.blueGrey.shade700);
                // Navigator.pushNamed(context, AlarmAnalysisIndex.route);
              },
              child: SettingCard(
                title: translate('setting_page.alarm_analysis'),
                color: '#FF856F',
                iconData: LineIcons.researchgate,
                isInfoExit: false,
                info: '',
              ),
            ),
            InkWell(
              onTap: () {
                ShowSnackBar.showWithScaffold(
                    _scaffoldKey, context, Strings.commingSoon,
                    color: Colors.blueGrey.shade700);
              },
              child: SettingCard(
                title: translate('setting_page.notification_settings'),
                color: '#FFB341',
                iconData: Icons.notifications,
                isInfoExit: false,
                info: '',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, SelectLanguage.route);
              },
              child: SettingCard(
                  title: translate('setting_page.language'),
                  color: '#6481FF',
                  iconData: Icons.translate,
                  isInfoExit: false,
                  info: ''),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Contact.route);
              },
              child: SettingCard(
                  title: translate('setting_page.contact'),
                  color: '#FFCC36',
                  iconData: Icons.chat_rounded,
                  isInfoExit: false,
                  info: ''),
            ),
            InkWell(
              onTap: () {
                ShowSnackBar.showWithScaffold(
                    _scaffoldKey, context, Strings.commingSoon,
                    color: Colors.blueGrey.shade700);
              },
              child: SettingCard(
                  title: translate('setting_page.live_chat'),
                  color: '#9761EF',
                  iconData: Icons.chat_rounded,
                  isInfoExit: false,
                  info: ''),
            ),
            InkWell(
              onTap: () {
                ShowSnackBar.showWithScaffold(
                    _scaffoldKey, context, Strings.commingSoon,
                    color: Colors.blueGrey.shade700);
              },
              child: SettingCard(
                  title: translate('setting_page.about_us'),
                  color: '#707070',
                  iconData: Icons.settings,
                  isInfoExit: false,
                  info: ''),
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
              child: SettingCard(
                  title: translate('setting_page.sign_out'),
                  color: '#FF7C7C',
                  iconData: Icons.logout,
                  isInfoExit: false,
                  info: ''),
            ),
          ]),
        ));
  }
}
