part of 'insurance_bloc.dart';

@immutable
abstract class InsuranceEvent {
  const InsuranceEvent();
}

class GetInsurance extends InsuranceEvent {
  GetInsurance();
}

class ShowInsuranceLoading extends InsuranceEvent {}

class RefreshInsurance extends InsuranceEvent {
  RefreshInsurance();
}
