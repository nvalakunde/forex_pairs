import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_pairs/bloc/history/history_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_bloc.dart';
import 'package:forex_pairs/bloc/main_page/forex_event.dart';
import 'package:forex_pairs/bloc/main_page/forex_state.dart';
import 'package:forex_pairs/pages/history_page.dart';
import 'package:forex_pairs/services/websocket_service.dart';
import 'package:forex_pairs/utils/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ForexWebSocketService _webSocketService = ForexWebSocketService();
  late ForexBloc _forexBloc;
  Map<String, double> previousPrices =
      {}; // Store previous prices to detect changes

  @override
  void initState() {
    super.initState();
    _forexBloc = ForexBloc(_webSocketService);
    _forexBloc.add(ConnectWebSocketEvent());
  }

  @override
  void dispose() {
    _forexBloc.add(DisconnectWebSocketEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _forexBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Forex Market",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueGrey[900],
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _forexBloc.add(SubscribePairEvent("OANDA:EUR_USD"));
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Subscribe to EUR/USD",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _forexBloc.add(UnsubscribePairEvent("OANDA:EUR_USD"));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Unsubscribe EUR/USD",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ForexBloc, ForexState>(
                builder: (context, state) {
                  if (state is ForexInitial) {
                    _forexBloc.add(SubscribePairEvent("OANDA:EUR_USD"));
                  } else if (state is ForexDataUpdated) {
                    Map<String, dynamic> latestForexData = {};

                    for (var item in state.forexData["data"]) {
                      latestForexData[item["s"]] =
                          item; // Store latest data for each symbol
                    }

                    return ListView(
                      children: latestForexData.entries.map((entry) {
                        final String symbol = entry.key;
                        final item = entry.value;
                        final double price = item["p"].toDouble();
                        final double? previousPrice = previousPrices[symbol];

                        // Determine price movement color and arrow
                        Color priceColor = Colors.black;
                        String arrow = "";

                        if (previousPrice != null) {
                          if (price > previousPrice) {
                            priceColor = Colors.green;
                            arrow = "↑";
                          } else if (price < previousPrice) {
                            priceColor = Colors.red;
                            arrow = "↓";
                          }
                        }

                        // Store latest price for future comparisons
                        previousPrices[symbol] = price;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<HistoryBloc>(
                                      context), // Use existing HistoryBloc
                                  child: HistoryScreen(symbol: symbol),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              title: Text(
                                "EUR/USD",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "Time: ${HelperFunctions.formatTimestamp(item["t"])}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                      scale: animation, child: child),
                                ),
                                child: Text(
                                  "$arrow ${price.toStringAsFixed(5)}",
                                  key: ValueKey(price),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: priceColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
