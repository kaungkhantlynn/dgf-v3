part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent {
  const ContactEvent();
}

class GetContact extends ContactEvent {
  const GetContact();
}
