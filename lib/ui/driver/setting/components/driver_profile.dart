import 'package:fleetmanagement/bloc/driver_profile/driver_profile_bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_icons/line_icons.dart';

class DriverProfile extends StatefulWidget {
  static const String route = '/driver_profile';
  const DriverProfile({Key? key}) : super(key: key);

  @override
  _DriverProfileState createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.user'),
        ),
        body: BlocProvider<DriverProfileBloc>(create: (context) {
          return DriverProfileBloc(getIt<DriverRepository>())
            ..add(const GetDriverProfile());
        }, child: BlocBuilder<DriverProfileBloc, DriverProfileState>(
          builder: (context, state) {
            if (state is DriverProfileLoaded) {
              return Column(
                children: [
                  const Padding(padding: EdgeInsets.all(16.5)),
                  Container(
                      padding: const EdgeInsets.only(left: 22, right: 10, top: 12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.5, bottom: 23.5),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),
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
                                  state.driverProfileModel!.data!.name!,
                                  style: TextStyle(
                                      height: 1.2,
                                      color: Colors.grey.shade800,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Kanit'),
                                ),
                                Text(
                                  translate('driver.driver_name'),
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
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
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.driverProfileModel!.data!.licenseNumber!,
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
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('start_date'),
                              style: TextStyle(
                                  height: 1.2,
                                  color: Colors.grey.shade700,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kanit'),
                            ),
                            Text(
                              state.driverProfileModel!.data!.createdAt!,
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
                  Container(
                      padding: const EdgeInsets.only(left: 22, top: 16),
                      decoration: const BoxDecoration(color: Colors.white),
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 16, right: 22),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('driver.type'),
                              style: TextStyle(
                                  height: 1.2,
                                  color: Colors.grey.shade700,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kanit'),
                            ),
                            Text(
                              state.driverProfileModel!.data!.licenseType!,
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
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )));
  }
}
