
part of 'groupdetail_cubit.dart';


@immutable
abstract class GroupDetailState {}

class GroupDetailInitial extends GroupDetailState {}

class GroupDetailLoaded extends GroupDetailState {
  List<GroupDetailData>? groupDatas;

  GroupDetailLoaded({this.groupDatas});
}

class GroupListError extends GroupDetailState {}