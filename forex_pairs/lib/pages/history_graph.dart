import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:forex_pairs/models/historical_data.dart';

class HistoryGraph extends StatelessWidget {
  final TradeHistoryData data;

  const HistoryGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.close.length,
                (index) => FlSpot(index.toDouble(), data.close[index])),
            isCurved: true,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
