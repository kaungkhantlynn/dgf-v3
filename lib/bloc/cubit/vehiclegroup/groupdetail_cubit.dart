import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/network/api/tracking/tracking_api.dart';
import '../../../models/vehicle_group/group_detail.dart';

part 'groupdetail_state.dart';

class GroupDetailCubit extends Cubit<GroupDetailState> {

  final TrackingApi _trackingApi;

  GroupDetailCubit(this._trackingApi,
      ) : super(GroupDetailInitial());


  Future<void> loadGroupDetail(String groupName) async {
    try {
      var response = await _trackingApi.getGroupDetail(groupName);
      print('GDSUCCESS');
      emitLoadedData(response.data!);
    }catch (error){
      print('GDERROR ${error.toString()}');
      emitError();
    }
  }


  void emitLoading() => emit(GroupDetailInitial());
  void emitLoadedData(List<GroupDetailData>? groupData) => emit(GroupDetailLoaded(groupDatas: groupData));
  void emitError() => emit(GroupListError());
}