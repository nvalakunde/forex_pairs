import 'package:equatable/equatable.dart';
import 'package:forex_pairs/models/historical_data.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final TradeHistoryData data;

  HistoryLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
