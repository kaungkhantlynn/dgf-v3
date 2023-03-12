import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/core/utility/map/map_helper.dart';
import 'package:fleetmanagement/core/utility/map/model/map_cluster_property.dart';
import 'package:fleetmanagement/core/utility/map/model/map_marker.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_data.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';
import 'package:fleetmanagement/ui/tracking/maps/marker_icon.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'maps_tracking_state.dart';


class MapsTrackingCubit extends Cubit<MapsTrackingState> {
  MapsTrackingCubit() : super(MapsTrackingInitial());
  final Set<Marker> mapMarkers = {};
  final int _markersWidth = 120;
  GoogleMapController? controller;
  VehiclesDetailData? vehicleDetailsData;

  Fluster<MapMarker>? _clusterManager;
  ClusterProperty clusterProperty = MapHelper.instance.clusterProperty;

  void initMapController(GoogleMapController controller, BuildContext context,
      VehiclesDetailData? vhclData) {
    print('TRACKINGinitMapController STRMAP');

    this.controller = controller;
    vehicleDetailsData = vhclData!;
    print('TRACKING_VHD${vehicleDetailsData!.coordinate.longitude}');
    emit(MapsTrackingLoad(controller));
    _initMarkers(context);
  }

  Future _initMarkers(BuildContext context) async {
    print('INITMARKERTRACKING');
    print("TRACKING_MAPICON ${vehicleDetailsData!.mapIcon!}");
    var uuid = const Uuid();
    print('UUID${uuid.v4()}');
    // print('COORDINATE ' + coordinates![0].license.toString());
    // print("PARSE_COORDINATE"+coordinates[0].)
    // CustomMarkerManager markerManager = context.read<CustomMarkerManager>();
    var markers = <MapMarker>[];
    final markerIcon =
    await MarkerIcon.fromSvgUrl(context, vehicleDetailsData!.mapIcon!);

    markers.add(MapMarker(
      id: uuid.v4(),
      position:vehicleDetailsData!.coordinate,
      icon: markerIcon,
      // infoWindow: InfoWindow(title: data.license ?? "VB10")
    ));

    _clusterManager = await MapHelper.instance.initClusterManager(
      markers,
      clusterProperty.minClusterZoom!,
      clusterProperty.maxClusterZoom!,
    );

    updateMarkers();
    //  print('TRACKING_MARKER_ICON_INIT');
    // _markers.add(MapMarker(
    //    id: uuid.v4(),
    //    position: vehicleDetailsData!.coordinate,
    //    icon: markerIcon,
    //    // infoWindow: InfoWindow(title: data.license ?? "VB10")
    //  ));


  }

  Future<void> updateMarkers(
      {List<Marker>? markerList, double? updatedZoom}) async {
    print('UPDATE_TRACKING_MARKER STRMAP');

      if (_clusterManager == null || updatedZoom == clusterProperty.currentZoom) return;

      if (updatedZoom != null) clusterProperty.currentZoom = updatedZoom;
    final updatedMarkers = await MapHelper.instance.getClusterMarkers(
        _clusterManager!,
        clusterProperty.currentZoom!,
        clusterProperty.clusterColor!,
        clusterProperty.clusterTextColor!,
        clusterProperty.clusterWidth!);
    //
    //   final updatedMarkers = await MapHelper.instance.getClusterMarkers(_clusterManager!, clusterProperty.currentZoom!,
    //       clusterProperty.clusterColor!, clusterProperty.clusterTextColor!, clusterProperty.clusterWidth!);
    //   var customMarker = <Marker>[];
    //

    // print("MAPSTRACKING_SUPERMARKER " + updatedMarkers.length.toString());

    emit(MapsTrackingUpdate(Set.of(updatedMarkers)));

    // showMarkerInfoWindow(updatedMarkers.first);
  }

  void changeMarker(VehiclesDetailModel vehiclesDetailModel) {
    print('LATLNG_ANIMATE${vehiclesDetailModel.vehiclesDetailData!.coordinate.latitude}');
    if (controller != null) {
      // controller!.animateCamera(CameraUpdate.newLatLng(vehiclesDetailModel.vehiclesDetailData!.coordinate));

      controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
          tilt: 80,
          target: vehiclesDetailModel.vehiclesDetailData!.coordinate,
          zoom: 12)));
    }
  }

  void showMarkerInfoWindow(Marker marker) {
    try {
      controller!.showMarkerInfoWindow(marker.markerId);
    } catch (e) {
      Logger()
          .e("Cluster Circle Error(Doesn't found marker, marker in circle )");
    }
  }
}
