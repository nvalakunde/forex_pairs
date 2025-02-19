import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/bloc/history/history_event.dart';
import 'package:forex_pairs/bloc/history/history_state.dart';
import 'package:forex_pairs/models/forex_pair.dart';

class HistoryPage extends StatefulWidget {
  final ForexPair forexPair;

  const HistoryPage({super.key, required this.forexPair});
  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedPair = 'EURUSD'; // Default currency pair
  String selectedTimeframe = '60'; // Default timeframe (60 minutes)

  @override
  void initState() {
    selectedPair = widget.forexPair.symbol;
    super.initState();
    _loadHistoricalData();
  }

  void _loadHistoricalData() {
    final bloc = BlocProvider.of<HistoryBloc>(context);
    final currentTime = DateTime.now();
    final from =
        currentTime.subtract(Duration(days: 7)).millisecondsSinceEpoch ~/
            1000; // 7 days ago
    final to = currentTime.millisecondsSinceEpoch ~/ 1000; // Current time

    bloc.add(FetchHistoryDataEvent(
      symbol: selectedPair,
      resolution: selectedTimeframe,
      from: from,
      to: to,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historical Data for $selectedPair'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadHistoricalData, // Refresh button
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoadedState) {
            return Column(
              children: [
                _buildTimeframeSelector(),
                _buildChart(state.historicalData),
              ],
            );
          } else if (state is HistoryErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  // Dropdown to select time frame
  Widget _buildTimeframeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<String>(
        value: selectedTimeframe,
        onChanged: (String? newValue) {
          setState(() {
            selectedTimeframe = newValue!;
            _loadHistoricalData();
          });
        },
        items: <String>['60', '360', '720', 'D']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text('Timeframe: $value'),
          );
        }).toList(),
      ),
    );
  }

  // Build the chart using fl_chart package
  Widget _buildChart(List<Map<String, dynamic>> data) {
    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: data.map((candle) {
                final timestamp = candle['timestamp'];
                return FlSpot(
                  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
                      .millisecondsSinceEpoch
                      .toDouble(),
                  candle['close'].toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
