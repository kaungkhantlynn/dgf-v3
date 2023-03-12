import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_detail_model.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_detail_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/drivers.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_detail_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuels.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_type_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_type_detail_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_types.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_detail_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/acts.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_detail_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurances.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_detail_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_deatil_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_detail_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/devices.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_detail_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicle_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicle_detail_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicles.dart';
import 'package:fleetmanagement/models/other/contact_model.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/config_model.dart';
import '../../../../models/mng/driver_management/assistant/assistants.dart';
import '../../../../models/mng/sensor_management/sensor/sensors.dart';
import '../../../../models/mng/sensor_management/sensor_type/sensor_types.dart';
import '../../../../models/mng/vehicles_management/vehicle_type/vehicle_types.dart';
import '../../dio_client.dart';
import '../../rest_client.dart';

class MngApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  MngApi(this._dioClient, this._restClient);

  //fuel types
  Future<FuelTypes> getFueltypes() async {
    final res = await _dioClient.get(Endpoints.fuelTypes);
    return FuelTypes.fromJson(res);
  }
  Future<void> exportFuelType() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/fuel_type.xlsx';
    await _dioClient.download(Endpoints.fuelTypesExport,saveFilePath);
  }

  Future<SuccessModel> postFuelTypes(FormData formData) async {
    final res = await _dioClient.post(Endpoints.fuelTypes,data: formData);
    return SuccessModel.fromJson(res);
  }

  Future<SuccessModel> updateFuelTypes(int id,formData) async {
    final res = await _dioClient.put(Endpoints.fuelTypes +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }

  Future<SuccessModel> deleteFuelTypes(int id) async {
    final res = await _dioClient.delete(Endpoints.fuelTypes +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }

  Future<FuelTypeDetailData> getFueltypesShow(int id) async {
    final res = await _dioClient.get(Endpoints.fuelTypes +'/'+id.toString());
    return FuelTypeDetailData.fromJson(res);
  }


  //fuels
  Future<Fuel> getFuels() async {
    final res = await _dioClient.get(Endpoints.fuels);
    return Fuel.fromJson(res);
  }
  Future<void> exportFuel() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/fuels.xlsx';
    await _dioClient.download(Endpoints.fuelsExport,saveFilePath);
  }
  Future<SuccessModel> createFuel(FormData formData) async {
    final res = await _dioClient.post(Endpoints.fuels,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateFuel(int id,formData) async {
    final res = await _dioClient.put(Endpoints.fuels +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteFuel(int id) async {
    final res = await _dioClient.delete(Endpoints.fuels +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<FuelDetailData> getFuelShow(int id) async {
    final res = await _dioClient.get(Endpoints.fuels +'/'+id.toString());
    return FuelDetailData.fromJson(res);
  }

  //driver management
  //drivers
  Future<Drivers> getDrivers() async {
    final res = await _dioClient.get(Endpoints.drivers);
    return Drivers.fromJson(res);
  }

  // Future openFile() async {
  //   final file = await exportDriver();
  //   if (file == null) {
  //     return;
  //   }
  //   print('Path: ${file.path}');
  //   OpenFile.open(file.path);
  // }

  Future openExportFile() async{
    Directory appDocDir = await  getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/drivers.xlsx');



// I am using following URL --->https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg

// use this in the initState method to initialize



  }

  Future<File?> exportDriver() async {
    try{
      Directory appDocDir = await  getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/drivers.xlsx');
      final response =   await _dioClient.download(Endpoints.driverExport,'driver.xlsx',options:Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0
      ) );
      // final response = await Dio().get(Endpoints.driverExport,options: Options(
      //     responseType: ResponseType.bytes,
      //     followRedirects: false,
      //     receiveTimeout: 0
      // )
      // );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    }catch(e) {
      print("EXPORT_DRIVER_DIO_EROR ${e.toString()}");
      return null;
    }
  }
  Future<SuccessModel> postDriver(FormData formData) async {
    final res = await _dioClient.post(Endpoints.drivers,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateDriver(int id,formData) async {
    final res = await _dioClient.put(Endpoints.drivers +'/'+id.toString(),data: formData,);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteDriver(int id) async {
    final res = await _dioClient.delete(Endpoints.drivers +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  // Future<SuccessModel> deleteDriver(int id,FormData formData) async {
  //   final res = await _dioClient.post(Endpoints.drivers +'/'+id.toString(),data: formData);
  //   return SuccessModel.fromJson(res);
  // }
  Future<DriverDetailData> getDriverShow(int id) async {
    final res = await _dioClient.get(Endpoints.drivers +'/'+id.toString());
    return DriverDetailData.fromJson(res);
  }

  //assistant
  Future<Assistants> getAssistants() async {
    final res = await _dioClient.get(Endpoints.assistants);
    return Assistants.fromJson(res);
  }
  Future<void> exportAssistants() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/assistants.xlsx';
    await _dioClient.download(Endpoints.assistantsExport,saveFilePath);
  }
  Future<SuccessModel> postAssistant(FormData formData) async {
    final res = await _dioClient.post(Endpoints.assistants,data: formData);
    return SuccessModel.fromJson(res);
  }

  Future<SuccessModel> updateAssistant(int id,formData) async {
    final res = await _dioClient.put(Endpoints.assistants +'/'+id.toString(),data: formData,
      // options: Options(headers: {
      // HttpHeaders.contentTypeHeader: "application/json",
      // }),
    );
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteAssistant(int id) async {
    final res = await _dioClient.delete(Endpoints.assistants +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<AssistantDetailModel> getAssistantShow(int id) async {
    final res = await _dioClient.get(Endpoints.assistants +'/'+id.toString());
    return AssistantDetailModel.fromJson(res);
  }

  //insurance management
  //act
  Future<Acts> getActs() async {
    final res = await _dioClient.get(Endpoints.acts);
    return Acts.fromJson(res);
  }
  Future<void> exportAct() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/acts.xlsx';
    await _dioClient.download(Endpoints.actsExport,saveFilePath);
  }
  Future<SuccessModel> postAct(FormData formData) async {
    final res = await _dioClient.post(Endpoints.acts,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateAct(int id,formData) async {
    final res = await _dioClient.put(Endpoints.acts +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteAct(int id) async {
    final res = await _dioClient.delete(Endpoints.acts +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<ActDetailData> getActShow(int id) async {
    final res = await _dioClient.get(Endpoints.acts +'/'+id.toString());
    return ActDetailData.fromJson(res);
  }

  //insurance
  Future<Insurances> getInsurance() async {
    final res = await _dioClient.get(Endpoints.insurances);
    return Insurances.fromJson(res);
  }
  Future<void> exportInsurance() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/insurances.xlsx';
    await _dioClient.download(Endpoints.insurancesExport,saveFilePath);
  }
  Future<SuccessModel> postInsurance(FormData formData) async {
    final res = await _dioClient.post(Endpoints.insurances,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateInsurance(int id,formData) async {
    final res = await _dioClient.put(Endpoints.insurances +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteInsurance(int id) async {
    final res = await _dioClient.delete(Endpoints.insurances +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<InsuranceDetailData> getInsuranceShow(int id) async {
    final res = await _dioClient.get(Endpoints.insurances +'/'+id.toString());
    return InsuranceDetailData.fromJson(res);
  }

  //sensor management
  // sensor
  Future<Sensors> getSensors() async {
    final res = await _dioClient.get(Endpoints.sensors);
    return Sensors.fromJson(res);
  }
  Future<void> exportSensor() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/sensors.xlsx';
    await _dioClient.download(Endpoints.sensorExport,saveFilePath);
  }
  Future<SuccessModel> postSensor(FormData formData) async {
    final res = await _dioClient.post(Endpoints.sensors,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> sensorUpdate(int id,formData) async {
    final res = await _dioClient.put(Endpoints.sensors +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteSensor(int id) async {
    final res = await _dioClient.delete(Endpoints.sensors +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<SensorDetailData> getSensorShow(int id) async {
    final res = await _dioClient.get(Endpoints.sensors +'/'+id.toString());
    return SensorDetailData.fromJson(res);
  }

  //sensor type
  Future<SensorTypes> getSensorsType() async {
    final res = await _dioClient.get(Endpoints.sensorTypes);
    return SensorTypes.fromJson(res);
  }
  Future<void> exportSensorType() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/sensors_type.xlsx';
    await _dioClient.download(Endpoints.sensorTypesExport,saveFilePath);
  }
  Future<SuccessModel> postSensorType(FormData formData) async {
    final res = await _dioClient.post(Endpoints.sensorTypes,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateSensorType(int id,formData) async {
    final res = await _dioClient.put(Endpoints.sensorTypes +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteSensorType(int id) async {
    final res = await _dioClient.delete(Endpoints.sensorTypes +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<SensorTypeDetailData> getSensorTypeShow(int id) async {
    final res = await _dioClient.get(Endpoints.sensorTypes +'/'+id.toString());
    return SensorTypeDetailData.fromJson(res);
  }

  //vehicle management
  //vehicle types
  Future<VehicleTypes> getVehicleType() async {
    final res = await _dioClient.get(Endpoints.vehicleTypes);
    return VehicleTypes.fromJson(res);
  }
  Future<void> exportVehicleType() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/vehicles_type.xlsx';
    await _dioClient.download(Endpoints.vehicleTypesExport,saveFilePath);
  }
  Future<SuccessModel> postVehicleType(FormData formData) async {
    final res = await _dioClient.post(Endpoints.vehicleTypes,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateVehicleType(int id,formData) async {
    final res = await _dioClient.put(Endpoints.vehicleTypes +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteVehicleType(int id) async {
    final res = await _dioClient.delete(Endpoints.vehicleTypes +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<VehicleTypeDetailData> getVehicleTypeShow(int id) async {
    final res = await _dioClient.get(Endpoints.vehicleTypes +'/'+id.toString());
    return VehicleTypeDetailData.fromJson(res);
  }

  //vehicles
  Future<Vehicles> getVehicles() async {
    final res = await _dioClient.get(Endpoints.vehicleList);
    return Vehicles.fromJson(res);
  }
  Future<void> exportVehicle() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/vehicles.xlsx';
    await _dioClient.download(Endpoints.vehiclesExport,saveFilePath);
  }
  Future<SuccessModel> postVehicle(FormData formData) async {
    final res = await _dioClient.post(Endpoints.vehicles,data: formData);
    return SuccessModel.fromJson(res);
  }

  //config
  Future<ConfigModel> getConfigs() async {
    final res = await _dioClient.get(Endpoints.configData);
    return ConfigModel.fromJson(res);
  }


  Future<SuccessModel> updateVehicle(int id,formData) async {
    final res = await _dioClient.put(Endpoints.vehicles +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteVehicle(int id) async {
    final res = await _dioClient.delete(Endpoints.vehicles +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<VehicleDetailData> getVehiclesShow(int id) async {
    final res = await _dioClient.get(Endpoints.vehicles +'/'+id.toString()+'/show');
    return VehicleDetailData.fromJson(res);
  }


  //devices

  Future<Devices> getDevices() async {
    final res = await _dioClient.get(Endpoints.devices);
    return Devices.fromJson(res);
  }
  Future<void> exportDevices() async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final saveFilePath = '${downloadDir.path}/devices.xlsx';
    await _dioClient.download(Endpoints.devicesExport,saveFilePath);
  }
  Future<SuccessModel> postDevices(FormData formData) async {
    final res = await _dioClient.post(Endpoints.devices,data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> updateDevices(int id,formData) async {
    final res = await _dioClient.put(Endpoints.devices +'/'+id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }
  Future<SuccessModel> deleteDevices(int id) async {
    final res = await _dioClient.delete(Endpoints.devices +'/'+id.toString());
    return SuccessModel.fromJson(res);
  }
  Future<DeviceDetailData> getDevicesShow(int id) async {
    final res = await _dioClient.get(Endpoints.devices +'/'+id.toString());
    return DeviceDetailData.fromJson(res);
  }
}
