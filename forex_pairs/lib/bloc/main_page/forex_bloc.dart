import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_event.dart';
import 'package:forex_pairs/bloc/main_page/forex_state.dart';
import 'package:forex_pairs/services/websocket_service.dart';

class ForexBloc extends Bloc<ForexEvent, ForexState> {
  final ForexWebSocketService _webSocketService;

  ForexBloc(this._webSocketService) : super(ForexInitial()) {
    on<ConnectWebSocketEvent>((event, emit) {
      _webSocketService.connect();
      _webSocketService.forexStream.listen((data) {
        add(UpdateForexDataEvent(data));
      });
    });

    on<DisconnectWebSocketEvent>((event, emit) {
      _webSocketService.disconnect();
    });

    on<SubscribePairEvent>((event, emit) {
      _webSocketService.subscribeToForexPair(event.symbol);
    });

    on<UnsubscribePairEvent>((event, emit) {
      _webSocketService.unsubscribeFromForexPair(event.symbol);
    });

    on<UpdateForexDataEvent>((event, emit) {
      emit(ForexDataUpdated(event.data));
    });
  }
}
