import 'candle.dart'; // Assuming Candle is defined in candle.dart

class HistoricalData {
  final List<Candle> candles;
  final String symbol;
  final String resolution; // E.g., "1d", "1h", "5m" for timeframes
  final int from; // Unix timestamp for the start date
  final int to; // Unix timestamp for the end date

  HistoricalData({
    required this.candles,
    required this.symbol,
    required this.resolution,
    required this.from,
    required this.to,
  });

  // Factory method to create HistoricalData from a list of JSON data
  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    List<Candle> candles = (json['candles'] as List)
        .map((candleJson) => Candle.fromJson(candleJson))
        .toList();

    return HistoricalData(
      candles: candles,
      symbol: json['symbol'],
      resolution: json['resolution'],
      from: json['from'],
      to: json['to'],
    );
  }

  // Method to convert HistoricalData instance to a map
  Map<String, dynamic> toJson() {
    return {
      'candles': candles.map((candle) => candle.toJson()).toList(),
      'symbol': symbol,
      'resolution': resolution,
      'from': from,
      'to': to,
    };
  }
}
