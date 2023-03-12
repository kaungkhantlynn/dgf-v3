import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';

import 'cluster_state.dart';

class ClusterCubit extends Cubit<ClusterState> {
  ClusterCubit(this.trackingRepository) : super(ClusterInitial());

  final TrackingRepository trackingRepository;


  Future<void> fetchLocationString(double lat, double lng) async{
    final result = await trackingRepository.getLongdoLocation(lat: lat.toString(),lng: lng.toString());
  }

  Future<void> fetchAllPoints({List<String>? status,List<String>? groupStatus,String? licenseKey}) async {
    print('FETCH NEXT TIME');
    try {
      final responseItems =
          await trackingRepository.getVehicles(status: status,groupKey: groupStatus,licenseKey: licenseKey);
      if (responseItems != null) {
        print("CLUSTER_DOWNLOADED");
        emit(ClusterCompleted(responseItems));
      } else {
        emit(ClusterError("Data Not Found"));
      }
    } on NoInternetConnectionException catch (error) {
      print("CLUSTERERROR ${error.message}");
      emit(ClusterError(error.message));
    } on BadRequestException catch (error ) {
      emit(ClusterError(error.message));
    }on InternalServerErrorException catch (error) {
      print("CLUSTERERROR ${error.message}");
      emit(ClusterError(error.message));
    } on UnauthorizedException catch (error) {
      print("CLUSTERERROR ${error.message}");
      emit(ClusterError(error.message));
    } catch (e) {
      print("CLUSTERERROR $e");
      emit(ClusterError('CLUSTERERROR $e'));
    }
  }
}
