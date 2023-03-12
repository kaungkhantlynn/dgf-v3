part of 'insurance_bloc.dart';

@immutable
abstract class InsuranceState {
  const InsuranceState();
}

class InsuranceInitial extends InsuranceState {}

class InsuranceLoading extends InsuranceState {}

class InsuranceLoaded extends InsuranceState {

  List<InsuranceData>? insuranceData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  InsuranceLoaded({this.insuranceData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'InsuranceLoaded { events: ${insuranceData!.length}, hasReachedMax: $hasReachedMax }';
}

class InsuranceError extends InsuranceState {
  final String? error;

  InsuranceError({this.error});
}
