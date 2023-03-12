part of 'tracking_history_cubit.dart';

@immutable
abstract class TrackingHistoryState {}

class TrackingHistoryInitial extends TrackingHistoryState {}

class TrackingHistoryLoading extends TrackingHistoryState {}

class TrackingHistoryError extends TrackingHistoryState {
  final String message;

  TrackingHistoryError(this.message);
}

class TrackingHistoryNoData extends TrackingHistoryState {
  final String message;

  TrackingHistoryNoData(this.message);
}

class TrackingHistoryCompleted extends TrackingHistoryState {
  TrackingHistoryModel? trackingHistoryModel;

  final int? selectedItem;

  TrackingHistoryCompleted(this.trackingHistoryModel, {this.selectedItem});

  TrackingHistoryCompleted copyWith({
    TrackingHistoryModel? trackingHistoryModel,
    int? selectedItem,
  }) {
    return TrackingHistoryCompleted(
        trackingHistoryModel ?? this.trackingHistoryModel,
        selectedItem: selectedItem ?? this.selectedItem);
  }
}
