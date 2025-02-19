import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForexEvent {}

class ConnectWebSocketEvent extends ForexEvent {}

class DisconnectWebSocketEvent extends ForexEvent {}

class SubscribePairEvent extends ForexEvent {
  final String symbol;
  SubscribePairEvent(this.symbol);
}

class UnsubscribePairEvent extends ForexEvent {
  final String symbol;
  UnsubscribePairEvent(this.symbol);
}

class UpdateForexDataEvent extends ForexEvent {
  final Map<String, dynamic> data;
  UpdateForexDataEvent(this.data);
}
