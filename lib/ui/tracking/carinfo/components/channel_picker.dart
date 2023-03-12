import 'package:fleetmanagement/bloc/channel/channel_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/camera_picker.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/live_video_index.dart';
import 'package:fleetmanagement/ui/widgets/language_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';

import '../playback/video_playback_list.dart';

class ChannelPicker extends StatefulWidget {
  String? license;
  String? date;
  String? fromWidget;

  ChannelPicker({Key? key, this.license, this.date, this.fromWidget})
      : super(key: key);
  @override
  _ChannelPickerState createState() => _ChannelPickerState();
}

class ChannelNumberArgs {
  String? channel;
  String? license;
  String? camera;
  int? cameraKey;
  String? date;
  ChannelNumberArgs(
      {this.channel, this.license, this.camera, this.cameraKey, this.date});
}

class _ChannelPickerState extends State<ChannelPicker> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String selectedChannel = "";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(create: (BuildContext context) {
      return ChannelBloc(getIt<VideoRepository>());
    }, child: BlocBuilder<ChannelBloc, ChannelState>(builder: (context, state) {
      if (state is ChannelInitial) {
        BlocProvider.of<ChannelBloc>(context)
            .add(GetChannel(license: widget.license));
      }
      if (state is FailedInternetConnection) {
        ShowSnackBar.showWithScaffold(_scaffoldKey, context, 'Check Internet Connection',
            color: Colors.redAccent);
      }
      if (state is ChannelLoaded) {
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
                            translate('app_bar.channel'),
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
                       translate('please_select_channel'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(
                      height: size.height - 380,
                      child: ListView.builder(
                          itemCount: state.channelDatas!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedChannel = state.channelDatas![index].key!;

                                  print("SELECTED_CHANNEL $selectedChannel");
                                });

                                if (selectedChannel == "1") {
                                  Navigator.of(context).pop();
                                  print("SELECTED_CHANNEL_EQUAL $selectedChannel");
                                  showMaterialModalBottomSheet(
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17)),
                                      elevation: 12,
                                      isDismissible: true,
                                      context: context,
                                      builder: (context) => CameraPicker(
                                          license: widget.license,
                                          date: widget.date,
                                          fromWidget: widget.fromWidget));
                                }
                                print('SELECTED $selectedChannel');
                              },
                              child: LanguageBtn(
                                text: state.channelDatas![index].name,
                                textColor: selectedChannel ==
                                        state.channelDatas![index].key!
                                    ? '#FFFFFF'
                                    : '#373E48',
                                bgColor: selectedChannel ==
                                        state.channelDatas![index].key!
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
                    if (selectedChannel.isNotEmpty) {
                      Navigator.of(context).pop();
                      if (selectedChannel == "1") {
                        print("SELECTED_CHANNEL_EQUAL $selectedChannel");
                        showMaterialModalBottomSheet(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17)),
                            elevation: 12,
                            isDismissible: true,
                            context: context,
                            builder: (context) => CameraPicker(
                                  license: widget.license,
                                  date: widget.date,
                                  fromWidget: widget.fromWidget,
                                ));
                      } else {
                        // Navigator.pushNamed(context, LiveVideoIndex.route,arguments: ChannelNumberArgs(channel:selectedChannel,license: widget.license,camera: '0'));
                        switch (widget.fromWidget) {
                          case Strings.liveVideo:
                            Navigator.pushNamed(context, LiveVideoIndex.route,
                                arguments: ChannelNumberArgs(
                                    channel: selectedChannel,
                                    license: widget.license,
                                    camera: '0',
                                    cameraKey: 0,
                                    date: widget.date)
                            );
                            break;
                          case Strings.playbackVideo:
                            // Navigator.pushNamed(context, VideoPlaybackList.route,
                            //     arguments: ChannelNumberArgs(
                            //         channel: selectedChannel,
                            //         license: widget.license,
                            //         date: widget.date));
                            Navigator.pushNamed(context, VideoPlaybackList.route,arguments: ChannelNumberArgs(channel:selectedChannel,license: widget.license,camera: '0',cameraKey: 0,date: widget.date));
                            break;
                        }
                      }
                    } else {
                      ShowSnackBar.showWithScaffold(
                          _scaffoldKey, context, translate('select_something'),
                          color: Colors.blueGrey.shade700);
                    }
                  },
                  child:  Text(
                    translate('submit'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));
  }
}
