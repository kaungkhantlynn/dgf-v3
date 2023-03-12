import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/core/utility/map/map_helper.dart';
import 'package:fleetmanagement/core/utility/map/model/map_cluster_property.dart';
import 'package:fleetmanagement/core/utility/map/model/map_marker.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart'
    as fgstv;

import 'street_view_tracking_state.dart';


class StreetViewTrackingCubit extends Cubit<StreetViewTrackingState> {
  StreetViewTrackingCubit() : super(StreetViewTrackingInitial());

  fgstv.StreetViewController? controller;
  VehiclesDetailModel? vehiclesDetailModel;

  Fluster<MapMarker>? _clusterManager;
  ClusterProperty clusterProperty = MapHelper.instance.clusterProperty;

  void initMapController(fgstv.StreetViewController controller,
      BuildContext context, VehiclesDetailModel? vhclData) {
    print('STREETMAPTRACKINGinitMapController');

    this.controller = controller;
    vehiclesDetailModel = vhclData!;
    print('STREETMAP_TRACKING_VHD${vehiclesDetailModel!.vehiclesDetailData!.coordinate.longitude}');
    emit(StreetViewTrackingLoad(controller));
  }

  void animatePosition(VehiclesDetailModel? vehiclesDetailModel) {
    print('ANIMATED_LAT_LNG_STREET ${vehiclesDetailModel!.vehiclesDetailData!.coordinate.latitude},${vehiclesDetailModel.vehiclesDetailData!.coordinate.longitude}');
    if (controller != null) {
      // controller!.animateCamera(CameraUpdate.newLatLng(vehiclesDetailModel.vehiclesDetailData!.coordinate));
      // controller!.animateTo(
      //   duration: 750,
      //   camera: fgstv.StreetViewPanoramaCamera(
      //       bearing: 90, tilt: 30, zoom: 3));
      controller!.setPosition(
          position: fgstv.LatLng(
              vehiclesDetailModel.vehiclesDetailData!.coordinate.latitude,
              vehiclesDetailModel.vehiclesDetailData!.coordinate.longitude),
          source: fgstv.StreetViewSource.outdoor);
      // controller!.animateTo(
      //   duration: 750,
      //   camera: fgstv.StreetViewPanoramaCamera(
      //       bearing: 20));

    }
    // 17.163428,104.156676
  }
}
