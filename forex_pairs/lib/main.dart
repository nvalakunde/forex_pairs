import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/services/finnhub_service.dart';
import 'package:forex_pairs/bloc/main_page/forex_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_event.dart';
import 'package:forex_pairs/repositories/forex_repository.dart';
import 'pages/main_page.dart';

void main() {
  final forexRepository = ForexRepository(FinnhubServiceImpl());

  runApp(
    BlocProvider(
      create: (_) => ForexBloc(forexRepository)..add(LoadForexPairs()),
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
