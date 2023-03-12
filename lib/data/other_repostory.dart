import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/other/contact_model.dart';

import '../models/device_status.dart';

class OtherRepository {
  //api object
  final OtherApi _otherApi;

  //shared pref object
  final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  OtherRepository(
    this._otherApi,
    this._sharedPreferenceHelper,
  );

  Future<ContactModel> getContact() async {
    return _otherApi.getContact();
  }


  Future<DeviceStatus> getDeviceStatus() async {
    return _otherApi.getDeviceStatus();
  }
}
