import 'package:equatable/equatable.dart';

abstract class HistoryEvent {}

class FetchHistoryData extends HistoryEvent {
  final String symbol;
  final String resolution;

  FetchHistoryData({required this.symbol, required this.resolution});
}
