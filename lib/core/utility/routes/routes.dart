import 'package:fleetmanagement/ui/auth/admin/admin_login.dart';
import 'package:fleetmanagement/ui/check_state.dart';
import 'package:fleetmanagement/ui/driver/jobs/route_detail.dart';
import 'package:fleetmanagement/ui/driver/jobs/sign_board.dart';
import 'package:fleetmanagement/ui/driver/setting/components/driver_profile.dart';
import 'package:fleetmanagement/ui/home/driver_home_index.dart';
import 'package:fleetmanagement/ui/home/home_index.dart';
import 'package:fleetmanagement/ui/setting/alarm_analysis/alarm_analysis_index.dart';
import 'package:fleetmanagement/ui/setting/contact/contact.dart';
import 'package:fleetmanagement/ui/setting/device_status/device_status_index.dart';
import 'package:fleetmanagement/ui/setting/language/select_language.dart';
import 'package:fleetmanagement/ui/splash/splash_screen.dart';
import 'package:fleetmanagement/ui/tracking/car_number_search.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/driver_information.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/fuel_graph/fuel_graph_index.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/job_description.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/live_video_and_map_index.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/live_video_index.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/mileage_analytics/mileage_analytics_index.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/playback_filter.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/single_playback.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/video_playback_list.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/route_description.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking/tracking.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_alarm_report.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_filter.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_index.dart';
import 'package:fleetmanagement/ui/tracking/tracking_filter.dart';
import 'package:fleetmanagement/ui/tracking/vehicle_group_detail_search.dart';
import 'package:fleetmanagement/ui/tracking/vehicle_group_search.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/add_driver.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/driver.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver/edit_driver.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_assistant/add_driver_assistant.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_assistant/driver_assistant.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_assistant/edit_driver_assistant.dart';
import 'package:fleetmanagement/ui/vehicle/driver_management/driver_management.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/add_consumption_rate.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/consumption_rate.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/consumption_rate/edit_consumption_rate.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_management.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/add_fuel_type.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/edit_fuel_type.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/fuel_type.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/add_insurance.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/edit_insurance.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance/insurance.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/insurance_management.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/add_wsu.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/edit_wsu.dart';
import 'package:fleetmanagement/ui/vehicle/insurance_management/wsu/wsu.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/add_sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/edit_sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor/sensor.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_management.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/add_sensor_type.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/edit_sensor_type.dart';
import 'package:fleetmanagement/ui/vehicle/sensor_management/sensor_type/sensor_type.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/add_tracker_management.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/edit_tracker.dart';
import 'package:fleetmanagement/ui/vehicle/tracking_management/tracking_management.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/add_vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/edit_vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle/vehicle.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_management.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/add_vehicle_type.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/edit_vehicle_type.dart';
import 'package:fleetmanagement/ui/vehicle/vehicle_management/vehicle_type/vehicle_type.dart';
import 'package:flutter/widgets.dart';

import '../../../ui/driver/jobs/job_filter.dart';
import '../../../ui/splash/loading_splash_driver.dart';
import '../../../ui/tracking/carinfo/livevideo/live_video_and_map.dart';
import '../../../ui/tracking/carinfo/livevideo/web_video_test.dart';
import '../../../ui/tracking/carinfo/playback/in_app_webview_screen.dart';
import '../../../ui/tracking/carinfo/tracking_history/tracking_history_play.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash_screen';
  static const String login = '/admin_login';
  static const String homeindex = '/home_index';
  static const String driverHomeindex = '/driver_home_index';
  static const String checkState = '/check_state';
  static const String trackingfilter = '/tracking_filter';
  static const String carNumberSearch = '/car_number_search';
  static const String vehicleGroupSearch = '/vehicle_group_search';
  static const String vehicleGroupDetailSearch = '/vehicle_group_detail_search';
  static const String carinfoMenu = '/car_info_menu';
  static const String driverInformation = '/driver_information';
  static const String jobDescription = '/job_description';
  static const String routeDescription = '/route_description';
  static const String milageAnalytics = '/milage_analytics';
  static const String fuelUsageGraph = '/fuel_graph_index';
  static const String liveVideo = '/live_video_index';
  static const String liveVideoWeb = '/live_video_web';
  static const String liveVideoAndMap = '/live_video_and_map';
  static const String trackingHistoryFilter = '/tracking_history_filter';
  static const String deviceStatusIndex = '/device_status_index';
  static const String alarmAnalysisIndex = '/alarm_analysis_index';
  static const String contact = '/contact';
  static const String language = '/select_language';
  static const String liveTracking = '/live_tracking';
  static const String trackingHistory = '/tracking_history';
  static const String trackingHistoryAlarmReport = '/tracking_history_alarm';
  static const String vodeoPlayBackFilter = '/playback_filter';
  static const String videoPlayback = '/video_playback';
  static const String playbackPlaying = '/playback_playing';
  static const String inAppWebViewScreen = '/in_app_webview_screen';

  //phase 2
  static const String trackerManagement = '/tracker_management';
  static const String fuelManagement = '/fuel_management';
  static const String fuelType = '/fuel_type';
  static const String consumptionRate = '/consumption_rate';
  static const String sensorManagement = '/sensor_management';
  static const String sensor = '/sensor';
  static const String sensorType = '/sensor_type';
  static const String vehicleManagement = '/vehicle_management';
  static const String vehicle = '/vehicle';
  static const String vehicleType = '/vehicle_type';
  static const String driverManagement = '/driver_management';
  static const String driver = '/driver';
  static const String driverAssistant = '/driver_assistant';
  static const String insuranceManagement = '/insurance_management';
  static const String insurance = '/insurance';
  static const String addWsu = '/add_wsu';
  static const String wsu = '/wsu';

  static const String addDriver = '/add_driver';
  static const String editDriver = '/edit_driver';
  static const String addDriverAssistant = '/add_driver_assistant';
  static const String editDriverAssistant = '/edit_driver_assistant';
  static const String addConsumptionRate = '/add_consumption_rate';
  static const String addFuelType = '/add_fuel_type';
  static const String addInsurance = '/add_insurance';
  static const String addSensor = '/add_sensor';
  static const String addSensorType = '/add_sensor_type';
  static const String addTrackerManagement = '/add_tracker_management';
  static const String addVehicle = '/add_vehicle';
  static const String addVehicleType = '/add_vehicle_type';

  //driver routes
  static const String routeDetail = '/route_detail';
  static const String driverProfile = '/driver_profile';
  static const String signBoard = '/sign_board';
  static const String jobFilter = '/job_filter';
  static const String loadingSplashDriver = '/loading_splash_driver';

  //edit management
  static const String editTracker = '/edit_tracker';
  static const String editFuelType = '/edit_fuel_type';
  static const String editConsumptionRate = '/edit_consumption_rate';
  static const String editSensorType = '/edit_sensor_type';
  static const String editSensor = '/edit_sensor';
  static const String editVehicle = '/edit_vehicle';
  static const String editVehicleType = '/edit_vehicle_type';
  static const String editWsu = '/edit_wsu';
  static const String editInsurance = '/edit_insurance';

  static const String trackingHistoryPlay = '/tracking_history_play';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => const AdminLogin(),
    homeindex: (BuildContext context) => const HomeIndex(),
    driverHomeindex: (BuildContext context) => const DriverHomeIndex(),
    loadingSplashDriver: (BuildContext context) => const LoadingSplashDriver(),
    checkState: (BuildContext context) => const CheckState(),
    trackingfilter: (BuildContext context) => const TrackingFilter(),
    carNumberSearch: (BuildContext context) => const CarNumberSearch(),
    vehicleGroupSearch: (BuildContext context) => const VehicleGroupSearch(),
    vehicleGroupDetailSearch: (BuildContext context) => const VehicleGroupDetailSearch(),
    carinfoMenu: (BuildContext context) => const CarInfoMenu(),
    driverInformation: (BuildContext context) => const DriverInformation(),
    jobDescription: (BuildContext context) => const JobDescription(),
    routeDescription: (BuildContext context) => const RouteDescription(),
    milageAnalytics: (BuildContext context) => const MileageAnalytics(),
    fuelUsageGraph: (BuildContext context) => const FuelGraphIndex(),
    liveVideo: (BuildContext context) => const LiveVideoIndex(),
    liveVideoWeb: (BuildContext context) => const WebVideoTest(),
    liveVideoAndMap: (BuildContext context) => const LiveVideoAndMap(),
    trackingHistoryFilter: (BuildContext context) => const TrackingHistoryFilter(),
    deviceStatusIndex: (BuildContext context) => const DeviceStatusIndex(),
    alarmAnalysisIndex: (BuildContext context) => const AlarmAnalysisIndex(),
    contact: (BuildContext context) => const Contact(),
    language: (BuildContext context) => const SelectLanguage(),
    liveTracking: (BuildContext context) => const Tracking(),
    trackingHistory: (BuildContext context) => const TrackingHistoryIndex(),
    trackingHistoryAlarmReport: (BuildContext context) => const TrackingHistoryAlarmReport(),
    vodeoPlayBackFilter: (BuildContext context) => const PlaybackFilter(),
    videoPlayback: (BuildContext context) => const VideoPlaybackList(),
    playbackPlaying: (BuildContext context) => SinglePlayback(),
    routeDetail: (BuildContext context) => const RouteDetail(),
    driverProfile: (BuildContext context) => const DriverProfile(),
    trackerManagement: (BuildContext context) => const TrackerManagement(),
    fuelManagement: (BuildContext context) => const FuelManagement(),
    fuelType: (BuildContext context) => const FuelType(),
    consumptionRate: (BuildContext context) => const ConsumptionRate(),
    sensorManagement: (BuildContext context) => const SensorManagement(),
    sensor: (BuildContext context) => const Sensor(),
    sensorType: (BuildContext context) => const SensorType(),
    vehicleManagement: (BuildContext context) => const VehicleManagement(),
    inAppWebViewScreen: (BuildContext context) =>  InAppWebViewScreen(),
    vehicle: (BuildContext context) => const Vehicle(),
    vehicleType: (BuildContext context) => const VehicleType(),
    driverManagement: (BuildContext context) => const DriverManagement(),
    driver: (BuildContext context) => const Driver(),
    // driver: (BuildContext context) => Driver(),
    // driver: (BuildContext context) => Driver(),
    driverAssistant: (BuildContext context) => const DriverAssistant(),
    insuranceManagement: (BuildContext context) => const InsuranceManagement(),
    insurance: (BuildContext context) => const Insurance(),
    addWsu: (BuildContext context) => const AddWsu(),
    wsu: (BuildContext context) => const Wsu(),
    addDriver: (BuildContext context) => const AddDriver(),
    editDriver:(BuildContext context) => const EditDriver(),
    addDriverAssistant: (BuildContext context) => const AddDriverAssistant(),
    editDriverAssistant: (BuildContext context) => const EditDriverAssistant(),
    addConsumptionRate: (BuildContext context) => const AddConsumptionRate(),
    addFuelType: (BuildContext context) => const AddFuelType(),
    addInsurance: (BuildContext context) => const AddInsurance(),
    addSensor: (BuildContext context) => const AddSensor(),
    addSensorType: (BuildContext context) => const AddSensorType(),
    addTrackerManagement: (BuildContext context) => const AddTrackerManagement(),
    addVehicle: (BuildContext context) => const AddVehicle(),
    addVehicleType: (BuildContext context) => const AddVehicleType(),
    signBoard: (BuildContext context) => const SignBoard(),
    jobFilter: (BuildContext context) => const JobFilter(),

    //edit management
    editTracker: (BuildContext context) => const EditTracker(),
    editFuelType: (BuildContext context) => const EditFuelType(),
    editConsumptionRate: (BuildContext context) => const EditConsumptionRate(),
    editSensorType: (BuildContext context) => const EditSensorType(),
    editSensor: (BuildContext context) => const EditSensor(),
    editVehicle: (BuildContext context) => const EditVehicle(),
    editVehicleType: (BuildContext context) => const EditVehicleType(),
    editWsu: (BuildContext context) => const EditWsu(),
    editInsurance: (BuildContext context) => const EditInsurance(),

    trackingHistoryPlay: (BuildContext context) => TrackingHistoryPlay(),
  };
}
