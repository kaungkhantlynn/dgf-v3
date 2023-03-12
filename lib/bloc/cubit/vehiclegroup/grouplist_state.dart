
part of 'group_list_cubit.dart';

@immutable
abstract class GroupListState {}

class GroupListInitial extends GroupListState {}

class GroupListLoaded extends GroupListState {
  List<String>? listofgroup;

  GroupListLoaded({this.listofgroup});
}

class GroupListError extends GroupListState {}