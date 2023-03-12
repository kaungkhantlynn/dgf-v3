import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/models/device_status.dart';
import 'package:fleetmanagement/models/other/contact_model.dart';

import '../../../../models/noti_count.dart';
import '../../../../models/report_count.dart';
import '../../dio_client.dart';
import '../../rest_client.dart';

class OtherApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  OtherApi(this._dioClient, this._restClient);

  Future<ContactModel> getContact() async {
    final res = await _dioClient.get(Endpoints.contact);
    return ContactModel.fromJson(res);
  }

  Future<DeviceStatus> getDeviceStatus() async {
    final res = await _dioClient.get(Endpoints.deviceStatus);
    return DeviceStatus.fromJson(res);
  }

  Future<ReportCount> getReportCount(String keyword) async {
    final res = await _dioClient.get("${Endpoints.reportAlarm}/$keyword/count");
    return ReportCount.fromJson(res);
  }

  Future<NotiCount> getDriverNotiCount() async {
    final res = await _dioClient.get(Endpoints.notificationCount);
    return NotiCount.fromJson(res);
  }
}
