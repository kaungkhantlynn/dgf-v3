
import 'package:fleetmanagement/ui/fleet_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'config/flavor_config.dart';
import 'core/utility/locale/translate_preferences.dart';
import 'di/components/service_locator.dart';
import 'core/utility/simple_bloc_observer.dart';
import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }

main() async {
  Bloc.observer = SimpleBlocObserver();
  Config.appFlavor = Flavor.PHASETHREEDEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: true);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
  // print('FCM User granted permission: ${settings.authorizationStatus}');
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //
  //
  //   }
  // });
  // localization
  var delegate = await LocalizationDelegate.create(
      preferences: TranslatePreferences(),
      basePath: 'assets/i18n/',
      fallbackLocale: 'th',
      supportedLocales: ['en_US', 'th', 'th_2']);

  // await di.init();
  await setPreferredOrientations();
  await setupLocator();
  runApp(LocalizedApp(delegate, const FleetManagement()));

}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
