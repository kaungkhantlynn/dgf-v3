import 'package:fleetmanagement/bloc/contact/contact_bloc.dart';
import 'package:fleetmanagement/data/other_repostory.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/setting/contact/contact_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  static const String route = '/contact';
  const Contact({Key? key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  Future<void>? _launched;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendMail(String mailAddress) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: mailAddress,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _textMe(String number, String body) async {
    // Android
    final uri = 'sms:+95 $number?body=$body';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      final uri = 'sms:+95 $number?body=$body';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<void>(future: _launched, builder: _launchStatus);
    return BlocProvider(
      create: (BuildContext context) {
        return ContactBloc(getIt<OtherRepository>());
      },
      child: Scaffold(
          appBar: AppbarPage(
            title: 'Contact',
          ),
          body: BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if (state is ContactInitial) {
                BlocProvider.of<ContactBloc>(context).add(const GetContact());
              }

              if (state is FailedInternetConnection) {
                ShowSnackBar.showWithScaffold(_scaffoldKey, context, 'Check Internet Connection',
                    color: Colors.redAccent);
              }
              if (state is ContactLoaded) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            _launched = _makePhoneCall('tel:${state.contactModel!.phone!.actionValue!}');
                          }),
                          child: ContactCard(
                              color: '#1F242B',
                              title: state.contactModel!.phone!.display!,
                              iconData: Icons.phone),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            _launched = _launchInBrowser('https://${state.contactModel!.facebook!.actionValue!}');
                          }),
                          child: ContactCard(
                              color: '#4F90FD',
                              title: state.contactModel!.facebook!.display!,
                              iconData: LineIcons.facebookF),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            _launched = _launchInBrowser('https://${state.contactModel!.line!.actionValue!}');
                          }),
                          child: ContactCard(
                              color: '#00D600',
                              title: state.contactModel!.line!.display!,
                              iconData: LineIcons.line),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            _sendMail(state.contactModel!.mail!.actionValue!);
                          }),
                          child: ContactCard(
                              color: '#4F90FD',
                              title: state.contactModel!.mail!.display!,
                              iconData: LineIcons.envelope),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            ShowSnackBar.show(context, 'Comming Soon',
                                color: Colors.green.shade800);
                          }),
                          child: ContactCard(
                              color: '#FF4D36',
                              title: state.contactModel!.liveChat!.display!,
                              iconData: LineIcons.sms),
                        )
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
