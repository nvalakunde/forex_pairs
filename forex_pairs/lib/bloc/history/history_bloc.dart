import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/repositories/forex_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ForexRepository _repository;

  HistoryBloc(this._repository) : super(HistoryInitialState());

  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    if (event is FetchHistoryDataEvent) {
      yield HistoryLoadingState();

      try {
        final data = await _repository.getHistoricalData(
          event.symbol,
        );
        yield HistoryLoadedState(historicalData: data);
      } catch (e) {
        yield HistoryErrorState("Loading Failed", error: e.toString());
      }
    }
  }
}
