import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/core/utility/map/map_helper.dart';
import 'package:fleetmanagement/core/utility/map/model/map_cluster_property.dart';
import 'package:fleetmanagement/core/utility/map/model/map_marker.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_data.dart';
import 'package:fleetmanagement/ui/tracking/maps/marker_icon.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'maps_cluster_state.dart';

class MapsClusterCubit extends Cubit<MapsClusterState> {
  MapsClusterCubit() : super(MapsClusterInitial());
  final Set<Marker> mapMarkers = {};
  final int _markersWidth = 120;
  GoogleMapController? controller;
  List<VehiclesData>? coordinates;
  Fluster<MapMarker>? _clusterManager;

  TrackingRepository? trackingRepository = getIt<TrackingRepository>();

  ClusterProperty clusterProperty = MapHelper.instance.clusterProperty;

  void initMapController(GoogleMapController controller, BuildContext context,
      List<VehiclesData> coordinates, GlobalKey globalKey) {
    print('initMapController');
    this.controller = controller;
    this.coordinates = coordinates;
    emit(MapsClusterLoad(controller));
    _initMarkers(context, globalKey);
  }

  Future _initMarkers(BuildContext context, GlobalKey globalKey) async {

    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      print('INITMARKER');
      // print("COORDINATES " + coordinates!.length.toString());
      var uuid = const Uuid();
      // print('COORDINATE ' + coordinates![0].license.toString());
      // print("PARSE_COORDINATE"+coordinates[0].)
      // CustomMarkerManager markerManager = context.read<CustomMarkerManager>();

      var markers = <MapMarker>[];
      for (var i = 0; i < coordinates!.length; i++) {
        // final markerIcon = await MarkerIcon.fromSvgAsset(context,coordinates![i].license, coordinates![i].statusIcon.toString());
        // final markerIcon = await MarkerIcon.pictureAsset(assetPath: 'assets/car.png', width: 200, height: 400);

        final markerIcon =
        await MarkerIcon.fromSvgUrl(context, coordinates![i].mapIcon!);

        markers.add(MapMarker(
          id: uuid.v4(),
          position: coordinates![i].coordinate,
          icon: markerIcon,
          // infoWindow: InfoWindow(title: data.license ?? "VB10")
        ));
      }

      _clusterManager = await MapHelper.instance.initClusterManager(
        markers,
        clusterProperty.minClusterZoom!,
        clusterProperty.maxClusterZoom!,
      );
      print('CLUSTERMANAGER ${_clusterManager!.radius}');

      updateMarkers();
    }  else {
      emit(FailedInternetConnection());
    }

  }

  Future<void> updateMarkers([double? updatedZoom]) async {
    print('UPDATE_MARKER');

    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      if (_clusterManager == null || updatedZoom == clusterProperty.currentZoom) {
        return;
      }

      if (updatedZoom != null) clusterProperty.currentZoom = updatedZoom;

      final updatedMarkers = await MapHelper.instance.getClusterMarkers(
          _clusterManager!,
          clusterProperty.currentZoom!,
          clusterProperty.clusterColor!,
          clusterProperty.clusterTextColor!,
          clusterProperty.clusterWidth!);

      print("SUPERMARKER ${updatedMarkers.length}");

      emit(MapsClusterUpdate(Set.of(updatedMarkers)));
    }  else {
      emit(FailedInternetConnection());
    }

    // showMarkerInfoWindow(updatedMarkers.first);
  }

  void showMarkerInfoWindow(Marker marker) {
    try {
      controller!.showMarkerInfoWindow(marker.markerId);
    } catch (e) {
      Logger()
          .e("Cluster Circle Error(Doesn't found marker, marker in circle )");
    }
  }

  void changeMarker(int selectedIndex, VehiclesData coordinate ,LongdoLocationCubit longdoLocationCubit) {
    print('SELECT_INDEX $selectedIndex');
   longdoLocationCubit.fetchLocationString(coordinate.lat!,coordinate.lon!);
    // print('CHANGEMARKER'+coordinates!.first.coordinate.toString());
    // emit(MapsClusterSelectedDefaultMarker(selectedIndex));
    controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinate.coordinate, zoom: 19)));
    // updateMarkers(20);
  }

  void changeAllMarker(List<VehiclesData>? coordinates) {
    print('UPDATE_ALL_MARKER ${coordinates!.length}');
    // print('MARKER_LENGTH '+markers.length.toString());

    // if (coordinates.length> 0){
    //   for( int i = 0; i<coordinates.length; i++){
    //     print('LOOP_COORDINATE'+coordinates[i].coordinate.toString());
    //     controller!.animateCamera(CameraUpdate.newLatLng(coordinates[i].coordinate));
    //   }
    // }
    // emit(MapsClusterSelectedDefaultMarker)
    if (controller != null) {
      for (var element in coordinates) {
        print('LOOP_COORDINATE ${element.coordinate}');
        controller!.animateCamera(CameraUpdate.newLatLng(element.coordinate));
        // controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: element.coordinate,zoom: 17)));

      }
      controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: coordinates[trackingRepository!.cardVehicleIndex!].coordinate,
          zoom: 17)));
    }
  }
}
