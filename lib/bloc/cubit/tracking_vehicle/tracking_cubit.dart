import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';

import 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this.trackingRepository) : super(TrackingInitial());

  final TrackingRepository trackingRepository;

  Future<void> fetchPoint(String license, String status) async {
    try {
      final responseItems =
          await trackingRepository.getVehiclesDetail(license, status);
      if (responseItems != null) {
        emit(TrackingCompleted(responseItems));
      } else {
        emit(TrackingError("Data Not Found"));
      }
    } on NoInternetConnectionException catch (error) {
      emit(TrackingError(error.message));
    } on BadRequestException catch (error ) {
      emit(TrackingError(error.message));
    }on InternalServerErrorException catch (error) {
      emit(TrackingError(error.message));
    } on UnauthorizedException catch (error) {
      emit(TrackingError(error.message));
    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }
}
