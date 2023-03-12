part of 'config_bloc.dart';

@immutable
abstract class ConfigEvent {
  const ConfigEvent();
}

class GetConfig extends ConfigEvent {
  GetConfig();
}

class ShowConfigLoading extends ConfigEvent {}

class RefreshConfig extends ConfigEvent {
  RefreshConfig();
}
