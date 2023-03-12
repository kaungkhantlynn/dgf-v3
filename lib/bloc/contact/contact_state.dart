part of 'contact_bloc.dart';

@immutable
abstract class ContactState {
  @override
  List<Object> get props => [];
}
class FailedInternetConnection extends ContactState {}
class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  ContactModel? contactModel;

  ContactLoaded({this.contactModel});
}

class ContactError extends ContactState {
  String? message;
  ContactError({this.message});
}
