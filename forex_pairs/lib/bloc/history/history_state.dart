
abstract class HistoryState {}

class HistoryInitialState extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<Map<String, dynamic>> historicalData;

  HistoryLoadedState({required this.historicalData});
}

class HistoryErrorState extends HistoryState {
  final String error;

  HistoryErrorState(String string, {required this.error});
}
