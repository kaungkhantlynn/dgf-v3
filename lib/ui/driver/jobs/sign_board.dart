import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/save_finished_job/save_finish_job_bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/check_state.dart';
import 'package:fleetmanagement/ui/driver/jobs/jobs.dart';
import 'package:fleetmanagement/ui/driver/jobs/route_detail.dart';
import 'package:fleetmanagement/ui/home/driver_home_index.dart';
import 'package:fleetmanagement/ui/splash/splash_screen.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../bloc/routeplan/route_plan_bloc.dart';
import '../../splash/loading_splash_driver.dart';


class SignBoard extends StatefulWidget {
  static String route = '/sign_board';
  const SignBoard({Key? key}) : super(key: key);

  @override
  _SignBoardState createState() => _SignBoardState();
}

class _SignBoardState extends State<SignBoard> {
  // Initialise a controller. It will contains signature points, stroke width and pen color.
  // It will allow you to interact with the widget
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1.5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  File? imageFileOne, imageFileTwo, imageFileThree;
  File? compressedImageFileOne, compressedmageFileTwo, compressedmageFileThree;
  bool showBtnLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));

  }

  @override
  void didChangeDependencies() {
    // _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _navigator.pushAndRemoveUntil(..., (route) => ...);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SignBoardParam;
    var mediaQuery = MediaQuery.of(context);
    var formData = FormData();
    return MultiBlocProvider(providers: [
        BlocProvider(
        create: (BuildContext context){
      return SaveFinishJobBloc(getIt<DriverRepository>());
    },

    ),
      BlocProvider<RoutePlanBloc>(create: (context) {
        return RoutePlanBloc(getIt<DriverRepository>());
      }),

    ], child: BlocBuilder<SaveFinishJobBloc,SaveFinishJobState>(
        builder: (context,state){
          if (state is SaveFinishJobDid) {
            // Future.delayed(Duration.zero, () async {
            //   ShowSnackBar.show(context, 'Success Uploaded');
            // });
            BlocProvider.of<RoutePlanBloc>(context).add(const GetRoutePlan());
            Future.delayed(const Duration(seconds: 1));
            Future.delayed(const Duration(seconds: 1), () async {

              ShowSnackBar.show(context, translate('successfully_uploaded'));

              onBackHome(context);
            });
          }
          // if (state is GoBackFromSaveFinishJob){
          //
          //   Future.delayed(Duration.zero, () async {
          //     Phoenix.rebirth(context);
          //   });
          //
          //
          // }
          return Scaffold(
              appBar: AppbarPage(
                title: args.appBarTitle,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.2, horizontal: 15.5),
                      child: Text(
                        translate('driver.pictures_des'),
                        style: TextStyle(
                            color: HexColor('#373E48'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ),

                    // Photo from Camera
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:   Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          firstCameraPhotoContainter(mediaQuery),
                          secondCameraPhotoContainter(mediaQuery),
                          thirdCameraPhotoContainter(mediaQuery),

                        ],
                      ),),

                    //SIGNATURE CANVAS
                    singnatureCanvas(),

                    //OK AND CLEAR BUTTONS
                    functionButtons(),

                    // Expanded(child: Padding(padding: EdgeInsets.all(5.5)),),
                    SizedBox(
                      height: mediaQuery.size.height - 780,
                    ),

                    //Submit button

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () async {



                              if (_controller.isEmpty) {
                                ShowSnackBar.show(context, translate('driver.need_to_draw_sign'));
                              }  else if (imageFileOne!= null || imageFileTwo != null || imageFileThree != null){


                                final signImg = await _controller.toPngBytes();


                                final readyImgOne = compressedImageFileOne !=null ? await MultipartFile.fromFile(compressedImageFileOne!.path, filename: 'img_one.png') : null;
                                final readyImgTwo = compressedmageFileTwo !=null ?  await MultipartFile.fromFile(compressedmageFileTwo!.path, filename: 'img_two.png') : null;
                                final readyImgThree = compressedmageFileThree !=null ? await MultipartFile.fromFile(compressedmageFileThree!.path, filename: 'img_three.png') : null;






                                FormData formData = FormData.fromMap({

                                  'jobs[]': [
                                    readyImgOne,
                                    readyImgTwo,
                                    readyImgThree,
                                  ],
                                  'sign': MultipartFile.fromBytes(signImg!,filename: 'sign.png'),

                                });

                                // print(jsonEncode(formData));

                                BlocProvider.of<SaveFinishJobBloc>(context).add(SaveFinishJobPress(id: args.id!,formData: formData));
                              }else{
                                ShowSnackBar.show(context, translate('upload_photo'));
                              }



                            },
                            child: Padding(
                                padding: const EdgeInsets.all(12.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     Text(translate('submit')),
                                    const SizedBox(width: 2,),
                                    BlocBuilder<SaveFinishJobBloc,SaveFinishJobState>(
                                        builder: (context,state){
                                          if (state is SaveFinishJobLoading) {
                                            print("PRESS_SAVE_LOADING");
                                            return  const SpinKitChasingDots(
                                              color: Colors.white,
                                              size: 15.0,
                                            );
                                          }
                                          return Container();
                                        })
                                  ],
                                )
                            )),
                      ),
                    ),

                  ],
                ),
              )

          );

        }
    )) ;
  }

  _onSubmitFinish(int id, FormData formData) async {
    FocusScope.of(context).unfocus();
    // focusNode.unfocus();



   }

  Container functionButtons() {
    return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                ),
                //CLEAR CANVAS
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                ),
              ],
            ),
          );
  }

  // Signature Canvas
  Container singnatureCanvas() {
    return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(10)),
            child: Signature(
              controller: _controller,
              height: 300,
              backgroundColor: Colors.transparent,
            ),
          );
  }

  Container firstCameraPhotoContainter(MediaQueryData mediaQuery) {
    return Container(
                 child: imageFileOne != null
                     ? Stack(
                   children: [
                     Image.file(
                       imageFileOne!,
                       fit: BoxFit.fitHeight,
                       width: mediaQuery.size.width / 3.2,
                       height: mediaQuery.size.width / 3.4,
                     ),
                     Positioned(
                         top: 2,
                         right: 25,
                         child: InkWell(
                           onTap: () async{
                             print('IMAGE FILE ONE');
                             setState(() {
                               imageFileOne = null;
                             });
                           },
                           child: Container(
                             padding: const EdgeInsets.all(2.2),
                             decoration: const BoxDecoration(
                                 color: Colors.red,
                                 shape: BoxShape.circle),
                             child: const Icon(
                               Icons.close,
                               color: Colors.white,
                             ),
                           ),
                         )),
                   ],
                 )
                     : GestureDetector(
                   onTap: () async {
                     _getFromCameraOne();
                   },
                   child: Container(
                     padding:
                     EdgeInsets.all(mediaQuery.size.width / 9),
                     decoration: BoxDecoration(
                         border:
                         Border.all(color: Colors.grey.shade700),
                         borderRadius: BorderRadius.circular(10)),
                     child: const Icon(Icons.camera_alt_rounded),
                   ),
                 ));
  }

  Container secondCameraPhotoContainter(MediaQueryData mediaQuery) {
    return Container(
                 child: imageFileTwo != null
                     ? Stack(
                   children: [
                     Image.file(
                       imageFileTwo!,
                       fit: BoxFit.fitHeight,
                       width: mediaQuery.size.width / 3.2,
                       height: mediaQuery.size.width / 3.4,
                     ),
                     Positioned(
                         top: 2,
                         right: 25,
                         child: InkWell(
                           onTap: () async{
                             print('IMAGE FILE TWO');
                             setState(() {
                               imageFileTwo = null;
                             });
                           },
                           child: Container(
                             padding: const EdgeInsets.all(2.2),
                             decoration: const BoxDecoration(
                                 color: Colors.red,
                                 shape: BoxShape.circle),
                             child: const Icon(
                               Icons.close,
                               color: Colors.white,
                             ),
                           ),
                         )),
                   ],
                 )
                     : GestureDetector(
                   onTap: () async {
                     _getFromCameraTwo();
                   },
                   child: Container(
                     padding:
                     EdgeInsets.all(mediaQuery.size.width / 9),
                     decoration: BoxDecoration(
                         border:
                         Border.all(color: Colors.grey.shade700),
                         borderRadius: BorderRadius.circular(10)),
                     child: const Icon(Icons.camera_alt_rounded),
                   ),
                 ));
  }
  Container thirdCameraPhotoContainter(MediaQueryData mediaQuery) {
    return Container(
                 child: imageFileThree != null
                     ? Stack(
                   children: [
                     Image.file(
                       imageFileThree!,
                       fit: BoxFit.fitHeight,
                       width: mediaQuery.size.width / 3.2,
                       height: mediaQuery.size.width / 3.4,
                     ),
                     Positioned(
                         top: 2,
                         right: 25,
                         child: InkWell(
                           onTap: () async{
                             print('IMAGE FILE THREE');
                             setState(() {
                               imageFileThree = null;
                             });
                           },
                           child: Container(
                             padding: const EdgeInsets.all(2.2),
                             decoration: const BoxDecoration(
                                 color: Colors.red,
                                 shape: BoxShape.circle),
                             child: const Icon(
                               Icons.close,
                               color: Colors.white,
                             ),
                           ),
                         )),
                   ],
                 )
                     : GestureDetector(
                   onTap: () async {
                     _getFromCameraThree();
                   },
                   child: Container(
                     padding:
                     EdgeInsets.all(mediaQuery.size.width / 9),
                     decoration: BoxDecoration(
                         border:
                         Border.all(color: Colors.grey.shade700),
                         borderRadius: BorderRadius.circular(10)),
                     child: const Icon(Icons.camera_alt_rounded),
                   ),
                 ));
  }

  /// Get from Camera
  _getFromCameraOne() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFileOne = File(pickedFile.path);
        _compressImageOne();

      });
    }
  }

  _compressImageOne() async{
     compressedImageFileOne = await customCompressed(imagePathToCompress: imageFileOne);
    final sizeInKbImgOne = compressedImageFileOne!.lengthSync() / 1024;
    print("Compressed ImgOne $sizeInKbImgOne kb");
  }

  _getFromCameraTwo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFileTwo = File(pickedFile.path);
        _compressImageTwo();
      });
    }
  }

  _compressImageTwo() async{
    compressedmageFileTwo = await customCompressed(imagePathToCompress: imageFileTwo);
    final sizeInKbImgTwo = compressedmageFileTwo!.lengthSync() / 1024;
    print("Compressed ImgTwo $sizeInKbImgTwo kb");

  }

  _getFromCameraThree() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFileThree = File(pickedFile.path);
        _compressImgThree();
      });
    }
  }

  _compressImgThree() async{


    compressedmageFileThree = await customCompressed(imagePathToCompress: imageFileThree);
    final sizeInKbImgThree = compressedmageFileThree!.lengthSync() / 1024;
    print("Compressed ImgThree $sizeInKbImgThree kb");

  }

  Future<File> customCompressed({@required File? imagePathToCompress,quality = 100,percentage = 10}) async{

  var path = await FlutterNativeImage.compressImage(imagePathToCompress!.path,quality: 100,percentage: 10);
  return path;
 }



  void onBackHome(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          DriverHomeIndex.route, (Route<dynamic> route) => false);
    });
    // Navigator.of(context).popUntil((route) {
    //   if (route.isFirst) {
    //     (route.settings.arguments as Map)['result'] = 'jobcreated';
    //     return true;
    //   } else {
    //     return false;
    //   }
    // });
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.pushReplacementNamed(context,DriverHomeIndex.route);
  }
}
