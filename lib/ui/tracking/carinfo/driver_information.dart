import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/simple_info_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_icons/line_icons.dart';

class DriverInformation extends StatefulWidget {
  static const String route = '/driver_information';
  const DriverInformation({Key? key}) : super(key: key);

  @override
  _DriverInformationState createState() => _DriverInformationState();
}

class _DriverInformationState extends State<DriverInformation> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DriverArguments;
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.driver_information'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.10)),
            Container(
                padding: const EdgeInsets.only(left: 22, right: 10, top: 12),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Container(
                  padding: const EdgeInsets.only(top: 10.5, bottom: 23.5),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(right: 18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/original_bg.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            args.drivername!,
                            style: TextStyle(
                                height: 1.2,
                                color: Colors.grey.shade800,
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Kanit'),
                          ),
                          Text(
                            translate('driver_information_page.driver_name'),
                            style: TextStyle(
                                height: 1.2,
                                color: Colors.grey.shade400,
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Kanit'),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            const Padding(padding: EdgeInsets.all(10.10)),
            Container(
                padding: const EdgeInsets.only(left: 22, top: 16),
                decoration: const BoxDecoration(color: Colors.white),
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16, right: 22),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('driver_information_page.driving_license'),
                        style: TextStyle(
                            height: 1.2,
                            color: Colors.grey.shade700,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Kanit'),
                      ),
                      Icon(
                        LineIcons.identificationCard,
                        color: HexColor('#00BEB6'),
                        size: 32,
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(left: 22, top: 16),
                decoration: const BoxDecoration(color: Colors.white),
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16, right: 22),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('driver_information_page.driving_license'),
                        style: TextStyle(
                            height: 1.2,
                            color: Colors.grey.shade700,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Kanit'),
                      ),
                      Text(
                        args.driverLicense!,
                        style: TextStyle(
                            height: 1.2,
                            color: Colors.grey.shade500,
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Kanit'),
                      ),
                    ],
                  ),
                )),
            SimpleInfoCard(primaryText: translate('driver_information_page.type'), secondaryText: args.type!)
          ],
        ),
      )),
    );
  }
}
