import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/models/video/camera_data.dart';
import 'package:fleetmanagement/models/video/camera_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  VideoRepository videoRepository;

  CameraBloc(this.videoRepository) : super(CameraInitial());
  @override
  // TODO: implement initialState
  CameraState get initialState => CameraInitial();

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    final currentState = state;
    if (event is GetCamera) {
      bool isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        try {
          int pageToFetch = 1;
          List<CameraData> cameraModel = [];

          if (currentState is CameraLoaded) {
            // pageToFetch = currentState.page! + 1;
            cameraModel = currentState.cameraDatas!;
            print(cameraModel);
          }

          CameraModel allCameraModel =
          await videoRepository.getCameras(event.license!);

          bool hasReachMax = true;
          cameraModel.addAll(allCameraModel.data!);

          yield CameraLoaded(
              cameraDatas: cameraModel,
              page: pageToFetch,
              hasReachedMax: hasReachMax);
        } catch (e) {
          print("Division_EE$e");
          CameraError(error: e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }

    }
  }
}
