import 'package:fleetmanagement/bloc/camera/camera_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/camera_item.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/live_video_index.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/video_playback_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../widgets/snackbar.dart';

class CameraPicker extends StatefulWidget {
  String? license;
  String? date;
  String? fromWidget;

  CameraPicker({Key? key, this.license, this.date, this.fromWidget})
      : super(key: key);
  @override
  _CameraPickerState createState() => _CameraPickerState();
}

class _CameraPickerState extends State<CameraPicker> {
  late String selectedCamera = "";
  late int selectedKey;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(create: (BuildContext context) {
      return CameraBloc(getIt<VideoRepository>());
    }, child: BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      if (state is CameraInitial) {
        BlocProvider.of<CameraBloc>(context)
            .add(GetCamera(license: widget.license));
      }
      if (state is CameraLoaded) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 40),
          height: size.height - 130,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
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
                            translate('app_bar.camera'),
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w700,
                                fontSize: 19),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(
                        translate('please_select_camera'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(
                      height: size.height - 380,
                      child: ListView.builder(
                          itemCount: state.cameraDatas!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCamera =
                                      state.cameraDatas![index].value!;
                                  selectedKey = state.cameraDatas![index].key!;
                                });
                                print('SELECTED $selectedCamera');
                              },
                              child: CameraItem(
                                cameraName: state.cameraDatas![index].value,
                                status: state.cameraDatas![index].status!,
                                textColor: selectedCamera ==
                                        state.cameraDatas![index].value!
                                    ? '#FFFFFF'
                                    : '#373E48',
                                bgColor: selectedCamera ==
                                        state.cameraDatas![index].value!
                                    ? '#5B78FA'
                                    : '#FFFFFF',
                              ),
                            );
                          }))
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
                    print('CAMERA_PICKER ${widget.fromWidget!}');
                    switch (widget.fromWidget) {
                      case Strings.liveVideo:
                        print('CAMERA_LIVEVIDEO');
                        Navigator.pushNamed(context, LiveVideoIndex.route,
                            arguments: ChannelNumberArgs(
                                channel: '1',
                                license: widget.license,
                                camera: selectedCamera,
                                cameraKey: selectedKey,
                                date: widget.date));
                        break;
                      case Strings.playbackVideo:

                        Navigator.pushNamed(context, VideoPlaybackList.route,
                            arguments: ChannelNumberArgs(
                                channel: '1',
                                license: widget.license,
                                camera: selectedCamera,
                                cameraKey: selectedKey,
                                date: widget.date
                            ));
                        break;
                    }
                  },
                  child: Text(
                    translate('submit'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (state is FailedInternetConnection) {
        ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
            color: Colors.redAccent);
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));
  }
}
