import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/forex_repository.dart';
import 'forex_event.dart';
import 'forex_state.dart';

class ForexBloc extends Bloc<ForexEvent, ForexState> {
  final ForexRepository forexRepository;
  Timer? _timer;

  ForexBloc(this.forexRepository) : super(ForexInitial()) {
    on<LoadForexPairs>(_onLoadForexPairs);
    on<RefreshForexPairs>(_onRefreshForexPairs);

    // Start auto-refresh every 10 seconds
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(RefreshForexPairs());
    });
  }

  Future<void> _onLoadForexPairs(
      LoadForexPairs event, Emitter<ForexState> emit) async {
    emit(ForexLoading());
    try {
      final pairs = await forexRepository.getForexPairs();
      emit(ForexLoaded(pairs));
    } catch (e) {
      emit(ForexError("Failed to load Forex data"));
    }
  }

  Future<void> _onRefreshForexPairs(
      RefreshForexPairs event, Emitter<ForexState> emit) async {
    try {
      final pairs = await forexRepository.getForexPairs();
      emit(ForexLoaded(pairs));
    } catch (e) {
      emit(ForexError("Failed to refresh Forex data"));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Stop the timer when BLoC is closed
    return super.close();
  }
}
