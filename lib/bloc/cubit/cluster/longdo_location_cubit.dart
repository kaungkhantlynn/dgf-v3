import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';

import 'longdo_location_state.dart';

class LongdoLocationCubit extends Cubit<LongdoLocationState> {
  LongdoLocationCubit(this.trackingRepository) : super(LongdoLocationInitial());

  final TrackingRepository trackingRepository;


  Future<void> fetchLocationString(double lat, double lng) async{
    try{
      final responseItems = await trackingRepository.getLongdoLocation(lat: lat.toString(),lng: lng.toString());
      print(responseItems!.length.toString());
      print("LONGDO_LOCO_LENGTH");
      if (responseItems.isNotEmpty) {
        if (responseItems.first == null) {
          print("NULL LONGDO");
          emit(LongdoLocationError("Data Not Found"));
        }else{
          emit(LongdoLocationCompleted(responseItems));
        }
        print("LONGDO_LOCATION_DOWNLOADED");

      } else {
        emit(LongdoLocationError("Data Not Found"));
      }
    } catch (e) {
      print("LONGDOERROR $e");
      emit(LongdoLocationError('LONGDOERROR$e'));
    }
  }

}
