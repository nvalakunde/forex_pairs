import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/repositories/history_repository.dart';
import 'history_event.dart';
import 'history_state.dart';


class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc(this.repository) : super(HistoryLoading()) {
    on<FetchHistoryData>((event, emit) async {
      emit(HistoryLoading());
      try {
        final data = await repository.fetchCachedOrApiData(
            event.symbol, event.resolution);
        emit(HistoryLoaded(data));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
