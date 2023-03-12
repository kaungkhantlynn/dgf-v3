import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/network/api/mng/mng_api.dart';
import '../../../../models/config_model.dart';
part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc
    extends Bloc<ConfigEvent, ConfigState> {
  MngApi mngApi;

  ConfigBloc(this.mngApi) : super(ConfigInitial());

  @override
  Stream<ConfigState> mapEventToState(
      ConfigEvent event,
      ) async* {
    if (event is GetConfig) {
      yield* _mapEventSlugChange(event);
    }


  }

  Stream<ConfigState> _mapEventSlugChange(
      GetConfig event) async* {
    yield ConfigLoading();

    try {
      ConfigModel configModel =
      await mngApi.getConfigs();

      yield ConfigLoaded(configModel: configModel,success: true);
      print('CONDIF_LOADED');
    } catch (e) {
      print("CONFIG_ERROR ${e.toString()}");
      yield ConfigError(error: e.toString());
    }
  }

  @override
  // TODO: implement initialState
  ConfigState get initialState => ConfigInitial();
}
