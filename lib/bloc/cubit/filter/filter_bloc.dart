import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

import '../../../data/sharedpref/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
part 'filter_state.dart';
part 'filter_event.dart';


class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final SharedPreferenceHelper _sharedPrefsHelper = getIt<SharedPreferenceHelper>();

  FilterBloc()
      : super(InitialFilterState());

  @override
  Stream<FilterState> mapEventToState(
      FilterEvent event,
      ) async* {
    if (event is GetFilterEvent) {

      bool isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        _sharedPrefsHelper.clearLicenseKey();
        _sharedPrefsHelper.saveLicenseKey(event.keyword!);
        print("EVNLIS ${event.keyword}");
        yield FilterKeyReceived(license: event.keyword);
      }  else {
        yield FilterFailedInternetConnection();
      }

    }
  }
}