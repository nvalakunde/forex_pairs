import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_bloc.dart';
import 'package:forex_pairs/services/websocket_service.dart';
import 'pages/main_page.dart';

void main() {
  final forexWebSocketService = ForexWebSocketService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForexBloc(forexWebSocketService)),
      ],
      child: FXTMApp(),
    ),
  );
}

class FXTMApp extends StatelessWidget {
  const FXTMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}
