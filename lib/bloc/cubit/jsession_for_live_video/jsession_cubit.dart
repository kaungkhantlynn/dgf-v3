import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/bloc/cubit/jsession_for_live_video/jsession_state.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';

import 'jsession_state.dart';

class JsessionCubit extends Cubit<JsessionState> {
  JsessionCubit(this.trackingRepository) : super(JsessionInitial());

  final TrackingRepository trackingRepository;

  Future<void> fetchJsession( ) async {
    try {
      final response =
      await trackingRepository.getJsessionToken();
      if (response!= null) {
        emit(JsessionCompleted(response));
      } else {
        emit(JsessionError("Data Not Found"));
      }
    } on NoInternetConnectionException catch (error) {
      emit(JsessionError(error.message));
    } on BadRequestException catch (error ) {
      emit(JsessionError(error.message));
    }on InternalServerErrorException catch (error) {
      emit(JsessionError(error.message));
    } on UnauthorizedException catch (error) {
      emit(JsessionError(error.message));
    } catch (e) {
      emit(JsessionError(e.toString()));
    }
  }
}
