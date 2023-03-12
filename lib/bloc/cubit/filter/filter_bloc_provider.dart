import 'package:fleetmanagement/bloc/cubit/filter/filter_bloc.dart';
import 'package:flutter/material.dart';

class FilterBlocProvider extends InheritedWidget {
  final FilterBloc bloc;

  FilterBlocProvider({Key? key, Widget? child}) : bloc = FilterBloc(),super(child: child!);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static FilterBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<FilterBlocProvider>()
    as FilterBlocProvider)
        .bloc;
  }
}