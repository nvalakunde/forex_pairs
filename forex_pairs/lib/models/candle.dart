class Candle {
  final double open;
  final double high;
  final double low;
  final double close;
  final int timestamp; // Unix timestamp for the time period of the candle
  final double? volume; // Optional field for volume

  Candle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
    this.volume,
  });

  // Factory method to create a Candle from a map (e.g., JSON data)
  factory Candle.fromJson(Map<String, dynamic> json) {
    return Candle(
      open: json['o'].toDouble(),
      high: json['h'].toDouble(),
      low: json['l'].toDouble(),
      close: json['c'].toDouble(),
      timestamp: json['t'],
      volume: json['v']?.toDouble(),
    );
  }

  // Method to convert a Candle instance to a map
  Map<String, dynamic> toJson() {
    return {
      'o': open,
      'h': high,
      'l': low,
      'c': close,
      't': timestamp,
      'v': volume,
    };
  }

  // Method to calculate whether the candle is bullish or bearish
  bool get isBullish => close > open;
  bool get isBearish => open > close;
}
