part of 'config_bloc.dart';



@immutable
abstract class ConfigState {
  const ConfigState();
}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class FailedInternetConnection extends ConfigState {}

class ConfigLoaded extends ConfigState {

  ConfigModel? configModel;
  bool? success;


  ConfigLoaded({this.configModel,  this.success});

  @override
  String toString() =>
      'ConfigLoaded { events: ${configModel!} }';
}

class ConfigError extends ConfigState {
  final String? error;

  ConfigError({this.error});
}
