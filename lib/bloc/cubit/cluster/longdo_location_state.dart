
import '../../../models/tracking/longdo_location.dart';

abstract class LongdoLocationState {}

class LongdoLocationInitial extends LongdoLocationState {}

class LongdoLocationCompleted extends LongdoLocationState {
   List<LongdoLocation>? longdoLocation;

  LongdoLocationCompleted(this.longdoLocation);
}

class LongdoLocationError extends LongdoLocationState {
  final String message;

  LongdoLocationError(this.message);
}
