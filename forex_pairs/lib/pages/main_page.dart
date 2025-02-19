import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/pages/history_page.dart';
import 'package:forex_pairs/repositories/forex_repository.dart';
import 'package:forex_pairs/services/finnhub_service.dart';
import '../bloc/main_page/forex_bloc.dart';
import '../bloc/main_page/forex_event.dart';
import '../bloc/main_page/forex_state.dart';
import '../models/forex_pair.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FXTM Forex Tracker')),
      body: BlocBuilder<ForexBloc, ForexState>(
        builder: (context, state) {
          if (state is ForexLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ForexLoaded) {
            return _buildForexList(state.forexPairs, context);
          } else if (state is ForexError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press the button to load data.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ForexBloc>().add(LoadForexPairs()),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildForexList(List<ForexPair> forexPairs, BuildContext context) {
    return ListView.separated(
      itemCount: forexPairs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final pair = forexPairs[index];
        bool isPriceUp = pair.change >= 0;
        return ListTile(
          leading: Icon(
            isPriceUp ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPriceUp ? Colors.green : Colors.red,
          ),
          title: Text(pair.symbol,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Text('Price: ${pair.currentPrice.toStringAsFixed(4)}'),
          trailing: Text(
            '${pair.change >= 0 ? '+' : ''}${pair.change.toStringAsFixed(4)} (${pair.percentChange.toStringAsFixed(2)}%)',
            style: TextStyle(
                color: isPriceUp ? Colors.green : Colors.red, fontSize: 16),
          ),
          onTap: () {
            // Navigate to the HistoryPage with the HistoryBloc
            final historyBloc =
                HistoryBloc(ForexRepository(FinnhubServiceImpl()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This is yet to be implemented')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<HistoryBloc>(
                  create: (_) => historyBloc,
                  child: HistoryPage(
                    forexPair: pair,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
