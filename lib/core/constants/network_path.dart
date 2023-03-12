import 'package:fleetmanagement/core/constants/exception/route_path_not_found.dart';

enum NetworkPath { POINTS, POLYLINE, CLUSTER }

extension NetworkPathValue on NetworkPath {
  String get rawValue {
    switch (this) {
      case NetworkPath.POINTS:
        return '/api/v1/vehicles';
      case NetworkPath.CLUSTER:
        return '/api/v1/vehicles';
      case NetworkPath.POLYLINE:
        return '/api/v1/vehicles';
      default:
        throw RoutePathNotFound();
    }
  }
}
