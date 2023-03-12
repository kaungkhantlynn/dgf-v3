import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'live_tracking_state.dart';

class LiveTrackingCubit extends Cubit<LiveTrackingState> {
  LiveTrackingCubit(this.trackingRepository) : super(LiveTrackingInitial());

  final TrackingRepository trackingRepository;
  int page = 1;

  Future<void> fetchLivePoint(String license) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      print('FETCHLIVEPOINT $license');
      if (state is LiveTrackingLoading) return;
      final currentState = state;
      var oldPosts = <TracksData>[];

      if (currentState is LiveTrackingLoaded) {
        oldPosts = currentState.trackData!;
      }

      emit(LiveTrackingLoading(oldPosts, isFirstFetch: page == 1));

      trackingRepository.getLiveTracking(license, page).then((newPosts) {
        if (newPosts.pagination!.currentPage! <=
            newPosts.pagination!.totalPages!) {
          page++;
        }

        bool hasReachMax =
        newPosts.pagination!.currentPage! <= newPosts.pagination!.totalPages!
            ? false
            : true;
        final posts = (state as LiveTrackingLoading).oldPosts;
        posts!.addAll(newPosts.tracks!);

        for (var i = 0; i < posts.length; i++) {
          print('LOOPTEST BLOC ${posts[i].mlat!}');
          // emit(LiveTrackingLoaded(trackData: posts, coordinate: LatLng(double.parse(posts[i].mlat!),double.parse(posts[i].mlng!)),hasReachedMax: hasReachMax,page: page));
        }

        // print('POSTSIZE'+posts.length.toString());

        //
        // posts.forEach((element) {
        //   print('MYELEMENT '+element.toString());
        //
        // });
      });
    }  else {
      emit(FailedInternetConnection());
    }
  }
}
