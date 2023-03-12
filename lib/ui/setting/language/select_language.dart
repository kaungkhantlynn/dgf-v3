import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SelectLanguage extends StatefulWidget {
  static const String route = '/select_language';

  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String? selectedLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLanguage = 'english';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppbarPage(
        title: translate('app_bar.language'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: LanguageSelector(
        isPage: true,
      )))),
    );
  }
}
