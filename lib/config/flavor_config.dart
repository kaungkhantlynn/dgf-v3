import 'dart:io';

enum Flavor {
  PHASETHREEDEVELOPMENT,
  PHASETHREEDEVELOPMENTTWO,
  PREDEVELOPMENT,
  DEVELOPMENT,
  STAGING,
  RELEASE,
}

class Config {
  static Flavor appFlavor = Flavor.RELEASE;

  static String get apiRoot {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      case Flavor.STAGING:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      case Flavor.DEVELOPMENT:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      case Flavor.PREDEVELOPMENT:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      case Flavor.PHASETHREEDEVELOPMENT:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      case Flavor.PHASETHREEDEVELOPMENTTWO:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
      default:
        return 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/api/v1/';
    }
  }

  static String get apiKey {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      case Flavor.STAGING:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      case Flavor.DEVELOPMENT:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      case Flavor.PREDEVELOPMENT:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      case Flavor.PHASETHREEDEVELOPMENT:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      case Flavor.PHASETHREEDEVELOPMENTTWO:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
      default:
        return 'FLp2QYJ8vf1U4a5Z6AYESdDK4SMbpShm';
    }
  }

  static String get envName {
    switch (Config.appFlavor) {
      case Flavor.RELEASE:
        return "(RELEASE)";
      case Flavor.STAGING:
        return "(Staging)";
      case Flavor.DEVELOPMENT:
        return "(Dev)";
      case Flavor.PREDEVELOPMENT:
        return "(PreDev)";
      case Flavor.PHASETHREEDEVELOPMENT:
        return "(PhaseThreeDev)";
      case Flavor.PHASETHREEDEVELOPMENTTWO:
        return "(PhaseThreeDevTwo)";
      default:
        return "(PhaseThreeDevTwo)";
    }
  }

  static String get environment {
    switch (Config.appFlavor) {
      case Flavor.RELEASE:
        return "production";
      case Flavor.STAGING:
        return "staging";
      case Flavor.DEVELOPMENT:
        return "development";
      case Flavor.PREDEVELOPMENT:
        return "predevelopment";
      case Flavor.PHASETHREEDEVELOPMENT:
        return "phasethreedevelopmenttwo";
      case Flavor.PHASETHREEDEVELOPMENTTWO:
        return "phasethreedevelopmenttwo";
      default:
        return "phasethreedevelopmenttwo";
    }
  }

  static String get version {
    String androidVersion = "Version 1.0.0";
    String iosVersion = "Version 1.0.0";

    if (Platform.isAndroid) {
      switch (Config.appFlavor) {
        case Flavor.RELEASE:
          return androidVersion;
        case Flavor.STAGING:
          return "$androidVersion (staging)";
        case Flavor.DEVELOPMENT:
          return "$androidVersion (dev)";
        case Flavor.PREDEVELOPMENT:
          return "$androidVersion (predev)";
        case Flavor.PHASETHREEDEVELOPMENT:
          return "$androidVersion (phasethreedev)";
        case Flavor.PHASETHREEDEVELOPMENTTWO:
          return "$androidVersion (phasethreedevtwo)";

        default:
          return "$androidVersion (phasethreedevtwo)";
      }
    } else {
      switch (Config.appFlavor) {
        case Flavor.RELEASE:
          return iosVersion;
        case Flavor.STAGING:
          return "$iosVersion (staging)";
        case Flavor.DEVELOPMENT:
          return "$iosVersion (dev)";
        case Flavor.PREDEVELOPMENT:
          return "$androidVersion (predev)";
        case Flavor.PHASETHREEDEVELOPMENT:
          return "$androidVersion (phasethreedev)";
        case Flavor.PHASETHREEDEVELOPMENTTWO:
          return "$androidVersion (phasethreedevtwo)";
        default:
          return "$iosVersion (phasethreedevtwo)";
      }
    }
  }
}
