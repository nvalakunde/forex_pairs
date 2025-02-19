import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forex_pairs/constants/app_constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ForexWebSocketService {
  final String _webSocketUrl =
      "wss://ws.finnhub.io?token=${AppConstants.finHubAPIKey}";
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get forexStream => _streamController.stream;

  /// Connect to WebSocket
  void connect() {
    if (_channel != null) return; // Prevent duplicate connections

    _channel = IOWebSocketChannel.connect(Uri.parse(_webSocketUrl));

    _channel?.stream.listen(
      (message) {
        debugPrint("Received: $message");
        _handleIncomingMessage(message);
      },
      onError: (error) {
        debugPrint("WebSocket Error: $error");
        _reconnect(); // Auto-reconnect on error
      },
      onDone: () {
        debugPrint("WebSocket Connection Closed");
        _reconnect(); // Auto-reconnect on disconnection
      },
    );
  }

  /// Subscribe to a forex pair
  void subscribeToForexPair(String forexSymbol) {
    final subscriptionMessage = jsonEncode({
      "type": "subscribe",
      "symbol": forexSymbol,
    });
    _channel?.sink.add(subscriptionMessage);
  }

  /// Unsubscribe from a forex pair
  void unsubscribeFromForexPair(String forexSymbol) {
    final unsubscribeMessage = jsonEncode({
      "type": "unsubscribe",
      "symbol": forexSymbol,
    });
    _channel?.sink.add(unsubscribeMessage);
  }

  /// Handle incoming WebSocket messages
  void _handleIncomingMessage(String message) {
    try {
      final jsonData = jsonDecode(message);
      if (jsonData["data"] != null) {
        _streamController.add(jsonData);
      }
    } catch (e) {
      debugPrint("Error decoding WebSocket message: $e");
    }
  }

  /// Disconnect WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  /// Reconnect WebSocket after a delay
  void _reconnect() {
    Future.delayed(Duration(seconds: 3), () {
      debugPrint("Reconnecting WebSocket...");
      connect();
    });
  }
}
