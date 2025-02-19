import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/bloc/history/history_event.dart';
import 'package:forex_pairs/bloc/history/history_state.dart';
import 'package:forex_pairs/pages/history_graph.dart';

class HistoryScreen extends StatefulWidget {
  final String symbol;

  const HistoryScreen({super.key, required this.symbol});

  @override
  // ignore: library_private_types_in_public_api
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
            onChanged: (onChangeValue) {},
          ),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoaded) {
                  return HistoryGraph(data: state.data);
                } else if (state is HistoryError) {
                  return Center(
                      child: Text("To enable this features apply for premium"));
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
