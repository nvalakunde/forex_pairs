import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_bloc.dart';
import 'package:forex_pairs/constants/app_constants.dart';
import 'package:forex_pairs/repositories/history_repository.dart';
import 'package:forex_pairs/services/finnhub_service.dart';
import 'package:forex_pairs/services/websocket_service.dart';
import 'pages/main_page.dart';

void main() {
  final forexWebSocketService = ForexWebSocketService();
  final historyRepository =
      HistoryRepository(FinnhubServiceImpl(), apiService: FinnhubServiceImpl());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForexBloc(forexWebSocketService)),
        BlocProvider(create: (context) => HistoryBloc(historyRepository)),
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
      navigatorKey: AppConstants.navigatorKey,
      title: 'FXTM Forex Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}
