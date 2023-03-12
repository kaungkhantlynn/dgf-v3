import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/bloc/alarm_report/alarm_report_bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/other/keyword_search_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:meta/meta.dart';

part 'keyword_search_event.dart';
part 'keyword_search_state.dart';

class KeywordSearchBloc extends Bloc<KeywordSearchEvent, KeywordSearchState> {
  TrackingRepository trackingRepository;

  KeywordSearchBloc(this.trackingRepository)
      : super(InitialKeywordSearchState());

  @override
  Stream<KeywordSearchState> mapEventToState(
    KeywordSearchEvent event,
  ) async* {
    if (event is GetKeywordSearchEvent) {

      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          KeywordSearchModel keywordSearchModel =
          await trackingRepository.getKeywordSearch(event.keyword!);
          yield KeywordSearchLoaded(keywordSearchModel: keywordSearchModel);
        } on NoInternetConnectionException catch (error) {
          yield KeywordSearchError(error.message);
        } on BadRequestException catch (error ) {
          yield KeywordSearchError(error.message);
        } on InternalServerErrorException catch (error) {
          yield KeywordSearchError(error.message);
        } on UnauthorizedException catch (error) {
          yield KeywordSearchError(error.message);
        } catch (e) {
          print("error msg ${e.toString()}");
          yield KeywordSearchError(e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }

    }
  }
}
