import 'package:fleetmanagement/bloc/channel/channel_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/widgets/language_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import '../livevideo/live_video_and_map.dart';

class ChannelPickerWeb extends StatefulWidget {
  String? license;
  String? deviceId;
  String? status;
  String? speed;
  String? speedUnit;
  String? temperature;
  String? temperatureUnit;
  String? oil;
  String? oilUnit;
  String? mapIcon;
  String? date;

  String? fromWidget;

  ChannelPickerWeb({Key? key, this.license,this.deviceId, this.status,this.speed,this.speedUnit,this.temperature,this.temperatureUnit,this.oil,this.oilUnit,this.mapIcon,
    this.date, this.fromWidget})
      : super(key: key);
  @override
  _ChannelPickerWebState createState() => _ChannelPickerWebState();
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

class LiveVideoMapArguments {
  String? license;
  String? deviceId;
  String? status;
  String? speed;
  String? speedUnit;
  String? temperature;
  String? temperatureUnit;
  String? oil;
  String? oilUnit;
  String? mapIcon;
  String? channel;

  LiveVideoMapArguments(
      {this.license,
        this.deviceId,
        this.status,
        this.speed,
        this.speedUnit,
        this.temperature,
        this.temperatureUnit,
        this.oil,
        this.oilUnit,
        this.mapIcon,
        this.channel});
}


class _ChannelPickerWebState extends State<ChannelPickerWeb> {
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
        ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
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
                                  selectedChannel =
                                  state.channelDatas![index].key!;

                                  print("SELECTED_CHANNEL $selectedChannel");
                                });

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
                      switch (widget.fromWidget) {
                        case Strings.liveVideo:
                        Navigator.pushNamed(
                          context,
                          LiveVideoAndMap.route,
                          arguments: LiveVideoMapArguments(
                              license: widget.license,
                              deviceId: widget.deviceId,
                              status: '1',
                              speed: widget.speed!,
                              speedUnit: 'km/hr',
                              temperature: widget.temperature,
                              temperatureUnit:'°C',
                              oil: widget.oil,
                              oilUnit: 'L',
                              mapIcon: widget.mapIcon,
                            channel: selectedChannel
                          ),
                        );
                          // Navigator.pushNamed(context, LiveVideoIndex.route,
                          //     arguments: ChannelNumberArgs(
                          //         channel: selectedChannel,
                          //         license: widget.license,
                          //         camera: '0',
                          //         cameraKey: 0,
                          //         date: widget.date));
                          break;
                        case Strings.playbackVideo:
                          ShowSnackBar.showWithScaffold(
                              _scaffoldKey, context, translate('coming_soon'),
                              color: Colors.blueGrey.shade700);
                          // Navigator.pushNamed(context, VideoPlaybackList.route,arguments: ChannelNumberArgs(channel:selectedChannel,license: widget.license,camera: '0',cameraKey: 0,date: widget.date));
                          break;
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
