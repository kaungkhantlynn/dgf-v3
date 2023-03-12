import 'package:fleetmanagement/constants/languageConst.dart';
import 'package:fleetmanagement/ui/widgets/language_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

class LanguageSelector extends StatefulWidget {
  bool? isPage = false;
  LanguageSelector({Key? key, this.isPage}) : super(key: key);

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  //for language setting
  bool isSelected = false;
  late String selectedLanguage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var localizationDelegate = LocalizedApp.of(context).delegate;
    if (localizationDelegate.currentLocale.languageCode == "en") {
      setState(() {
        selectedLanguage = LanguageConst.ENGLISH;
      });
    } else if (localizationDelegate.currentLocale.languageCode == "th") {
      setState(() {
        selectedLanguage = LanguageConst.THAIONE;
      });
    } else if (localizationDelegate.currentLocale.languageCode == "th_2") {
      setState(() {
        selectedLanguage = LanguageConst.THAITWO;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 40),
        height: size.height - 130,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !widget.isPage!,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 1,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            translate('app_bar.language'),
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w700,
                                fontSize: 19),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.isPage!,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(
                        translate('please_select_language'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = LanguageConst.THAIONE;
                    });
                    print('SELECTED $selectedLanguage');
                  },
                  child: LanguageBtn(
                    text: 'ภาษาไทย',
                    textColor: selectedLanguage == LanguageConst.THAIONE
                        ? '#FFFFFF'
                        : '#373E48',
                    bgColor: selectedLanguage == LanguageConst.THAIONE
                        ? '#5B78FA'
                        : '#FFFFFF',
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = LanguageConst.ENGLISH;
                    });
                    print('SELECTED $selectedLanguage');
                  },
                  child: LanguageBtn(
                    text: 'English',
                    textColor: selectedLanguage == LanguageConst.ENGLISH
                        ? '#FFFFFF'
                        : '#373E48',
                    bgColor: selectedLanguage == LanguageConst.ENGLISH
                        ? '#5B78FA'
                        : '#FFFFFF',
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = LanguageConst.THAITWO;
                    });
                    print('SELECTED $selectedLanguage');
                  },
                  child: LanguageBtn(
                    text: 'ພາສາລາວ',
                    textColor: selectedLanguage == LanguageConst.THAITWO
                        ? '#FFFFFF'
                        : '#373E48',
                    bgColor: selectedLanguage == LanguageConst.THAITWO
                        ? '#5B78FA'
                        : '#FFFFFF',
                  ),
                ),
              ],
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B78FA'),
                  padding: const EdgeInsets.all(15.5),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  switch (selectedLanguage) {
                    case LanguageConst.THAIONE:
                      changeLocale(context, 'th_TH');
                      break;
                    case LanguageConst.ENGLISH:
                      changeLocale(context, 'en_US');
                      break;
                    case LanguageConst.THAITWO:
                      changeLocale(context, 'th_TH');
                      break;
                  }
                  // Navigator.of(context).pop();
                  Phoenix.rebirth(context);
                },
                child:  Text(
                  translate('submit'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
