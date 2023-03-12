import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/network/api/tracking/tracking_api.dart';

part 'grouplist_state.dart';

class GroupListCubit extends Cubit<GroupListState> {

  final TrackingApi _trackingApi;

  GroupListCubit(
      this._trackingApi,
      ) : super(GroupListInitial()) {
    loadGroups();
  }


  Future<void> loadGroups() async {
    try {
      var response = await _trackingApi.getGroupList();
      emitLoadedData(response.data);
    }catch (error){

       emitError();
    }
  }


  void emitLoading() => emit(GroupListInitial());
  void emitLoadedData(List<String>? listofgroup) => emit(GroupListLoaded(listofgroup: listofgroup));
  void emitError() => emit(GroupListError());
}