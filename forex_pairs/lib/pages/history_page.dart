import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/bloc/history/history_event.dart';
import 'package:forex_pairs/bloc/history/history_state.dart';
import 'package:forex_pairs/pages/history_graph.dart';
import 'package:forex_pairs/repositories/history_repository.dart';
import 'package:forex_pairs/services/finnhub_service.dart';

class HistoryScreen extends StatefulWidget {
  final String symbol;

  const HistoryScreen({Key? key, required this.symbol}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedResolution = "D"; // Daily

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HistoryBloc>(context).add(FetchHistoryData(
        symbol: widget.symbol, resolution: selectedResolution));
  }

  void _onResolutionChanged(String newResolution) {
    setState(() {
      selectedResolution = newResolution;
    });
    BlocProvider.of<HistoryBloc>(context).add(
        FetchHistoryData(symbol: widget.symbol, resolution: newResolution));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.symbol} Trade History")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedResolution,
            items: ["D", "H"].map((String res) {
              return DropdownMenuItem<String>(
                value: res,
                child: Text(res == "D" ? "Daily" : "Hourly"),
              );
            }).toList(),
            onChanged: (_onResolutionChanged) {},
          ),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoaded) {
                  return HistoryGraph(data: state.data);
                } else if (state is HistoryError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text("No Data"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
