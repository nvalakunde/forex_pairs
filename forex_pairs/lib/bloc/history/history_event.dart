import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchHistoryDataEvent extends HistoryEvent {
  final String symbol;
  final String resolution;
  final int from;
  final int to;

  FetchHistoryDataEvent({
    required this.symbol,
    required this.resolution,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [symbol, resolution, from, to];
}
