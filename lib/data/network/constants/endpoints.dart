
class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/";



  // receiveTimeout
  static const int receiveTimeout = 500000;

  // connectTimeout[kwf]
  static const int connectionTimeout = 500000;

  //auth driver
  // static const String driverLogin = baseUrl + "driver/login";

  // auth admin
  static const String adminLogin = "${baseUrl}login";

  // auth check
  static const String authcheck = "${baseUrl}auth/check";

  //vehicles list
  static const String vehicles = "${baseUrl}vehicles";

  // config data
  static const String configData = "${baseUrl}vehicle-list/config-data";

  //generate jsession for live video
  static const String jsession = "${baseUrl}generate-jession";

  //tracking
  static const String tracking = "${baseUrl}vehicles/tracking";

  //logout
  static const String logout = "${baseUrl}logout";

  //tracking history
  static const String trackingHistory = "${baseUrl}tracking-history";

  //tracking history alarm list
  static const String trackingHistoryAlarmList =
      "${baseUrl}tracking-history/list";

  //alarm report list
  static const String reportAlarm = "${baseUrl}report";
  static const String notificationCount = "${baseUrl}active-alarm-count";

  //vehicle filter
  static const String vehicleFilter = "${baseUrl}vehicles-summary";

  //vehicle group
  static const String vehicleGroupList = "${baseUrl}vehicle-groups";
  static const String vehicleGroupDetail = "${baseUrl}vehicle-groups/vehicles";

  //vehicle keyword search
  static const String keywordSearch = "${baseUrl}vehicles/autocomplete";

  //contact
  static const String contact = "${baseUrl}contact";

  //device status
  static const String deviceStatus = "${baseUrl}dashboard";

  //channel
  static const String channel = "${baseUrl}livestreaming/channels";

  //camera
  static const String camera = "${baseUrl}playback/cameras";

  //live video
  static const String livestreaming = "${baseUrl}livestreaming";

  //playback video
  static const String playback = "${baseUrl}playbacks";

  //driver //
  //today route playn
  static const String routePlans = baseUrl + "route-plans/today";
  static const String routePlanDetail = baseUrl + "route-plans";
  // static const String routePlans = "${baseUrl}route-plans"; // instead

  // finished job
  static const String finished = "${baseUrl}route-plans/finished"; // instead

  //post finish job
  static const String postFinish = "${baseUrl}route-plans/finish/";
  static const String postStart = "${baseUrl}route-plans/start/";
  static const String notification = "${baseUrl}route-plan-notifications";
  static const String profile = "${baseUrl}driver/profile";

  //mng
  //tracker management
  static const String devices = "${baseUrl}devices";
  static const String devicesExport = "${baseUrl}devices/export";

  //vehicle management
  //vehicle
  static const String vehicleList = "${baseUrl}vehicle-list";
  static const String vehiclesExport = "${baseUrl}vehicles/export";
  static const String actionVehicle = "${baseUrl}vehicles";
  //vehicle type
  static const String vehicleTypes = "${baseUrl}vehicle-types";
  static const String vehicleTypesExport = "${baseUrl}vehicle-types/export";

  //sensor management
  //sensors
  static const String sensors = "${baseUrl}sensors";
  static const String sensorExport = "${baseUrl}sensors/export";
  //sensor types
  static const String sensorTypes = "${baseUrl}sensor-types";
  static const String sensorTypesExport = "${baseUrl}sensor-types/export";

  //insurance management
  //act
  static const String acts = "${baseUrl}acts";
  static const String actsExport = "${baseUrl}acts/export";
  //insurances
  static const String insurances = "${baseUrl}insurances";
  static const String insurancesExport = "${baseUrl}insurances/export";

  //driver management
  //driver
  static const String drivers = "${baseUrl}drivers";
  static const String driverExport = '${baseUrl}drivers/export';
  //assistants
  static const String assistants = "${baseUrl}assistants";
  static const String assistantsExport = '${baseUrl}assistants/export';

  //fuel management
  //fuel
  static const String fuels = "${baseUrl}fuels";
  static const String fuelsExport = '${baseUrl}fuels/export';
  //fuel type
  static const String fuelTypes = "${baseUrl}fuel-types";
  static const String fuelTypesExport = "${baseUrl}fuel-types/export";


}
