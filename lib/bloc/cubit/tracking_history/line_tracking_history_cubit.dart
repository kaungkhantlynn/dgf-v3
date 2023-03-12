import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_data.dart';
import 'package:fleetmanagement/ui/tracking/maps/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'line_tracking_history_state.dart';

class LineTrackingHistoryCubit extends Cubit<LineTrackingHistoryState> {
  LineTrackingHistoryCubit() : super(LineTrackingHistoryStateInitial());

  List<Marker> markers = [];
  final int _markersWidth = 50;
  GoogleMapController? controller;

  void initMapController(GoogleMapController controller) {
    emit(LineTrackingHistoryStateLoad(controller));
  }

  Future<void> initMapControllerMarkers(GoogleMapController controller,
      BuildContext context, List<TrackingHistoryData> coordinates) async {
    for (var i = 0; i < coordinates.length; i++) {
      // final icon = await markerManager.getCustomMarker(
      //     value: i,
      //     clusterColor: Colors.orange,
      //     textColor: Colors.white,
      //     width: _markersWidth);
      final markerIcon = await MarkerIcon.svgAsset(
          assetName: pointSvgAsset(i, coordinates),
          context: context,
          size: pointSize(i, coordinates));
      // final icon = await MarkerIcon.circleCanvasWithText(size: Size(70, 70), text: getRouteText(i, coordinates),fontColor: Colors.white,fontSize: 27,circleColor: getRouteColor(i, coordinates));

      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: coordinates[i].coordinate,
          icon: markerIcon));
    }

    emit(LineTrackingHistoryStateMarkers(markers));
  }

  String pointSvgAsset(int i, List<TrackingHistoryData> coordinates) {
    if (i == 0) {
      return "assets/svg/routeA.svg";
    } else if (i == coordinates.length - 1) {
      return "assets/svg/routeB.svg";
    } else {
      return "assets/svg/point_car.svg";
    }
  }

  double pointSize(int i, List<TrackingHistoryData> coordinates) {
    if (i == 0) {
      return 40;
    } else if (i == coordinates.length - 1) {
      return 40;
    } else {
      return 20;
    }
  }

  String getRouteText(int i, List<TrackingHistoryData> coordinates) {
    if (i == 0) {
      return "A";
    } else if (i == coordinates.length - 1) {
      return "B";
    } else {
      return (i + 1).toString();
    }
  }

  Color getRouteColor(int i, List<TrackingHistoryData> coordinates) {
    if (i == 0) {
      return Colors.blueGrey.shade900;
    } else if (i == coordinates.length - 1) {
      return Colors.blueGrey.shade900;
    } else {
      return Colors.deepOrange;
    }
  }

// void updateMarkerWithNumber(int index, Coordinate coordinate) {
//   state.controller
//       .animateCamera(CameraUpdate.newLatLng(coordinate.coordinate));
//   emit(MapsMarkerChange(state.controller, index));
// }
//
// void changeMarker(int index, Coordinate coordinate) {
//   state.controller
//       .animateCamera(CameraUpdate.newLatLng(coordinate.coordinate));
//   emit(MapsMarkerChange(state.controller, index));
// }

}
