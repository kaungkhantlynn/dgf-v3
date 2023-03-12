import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/other_repostory.dart';
import 'package:fleetmanagement/models/other/contact_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  OtherRepository otherRepository;

  ContactBloc(this.otherRepository) : super(ContactInitial());

  @override
  Stream<ContactState> mapEventToState(
    ContactEvent event,
  ) async* {
    if (event is GetContact) {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          ContactModel contactModel = await otherRepository.getContact();
          yield ContactLoaded(contactModel: contactModel);
        } on NoInternetConnectionException catch (error) {
          yield ContactError(message: error.message);
        } on BadRequestException catch (error ) {
          yield ContactError(message: error.message);
        }on InternalServerErrorException catch (error) {
          yield ContactError(message: error.message);
        } on UnauthorizedException catch (error) {
          yield ContactError(message: error.message);
        } catch (e) {
          print("error msg ${e.toString()}");
          yield ContactError(message: e.toString());
        }
      }  else {
       yield FailedInternetConnection();
      }

    }
  }
}
