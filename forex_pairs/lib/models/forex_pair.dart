class ForexPair {
  final String symbol;
  final double currentPrice;
  final double change;
  final double percentChange;

  ForexPair({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.percentChange,
  });

  factory ForexPair.fromJson(Map<String, dynamic> json) {
    return ForexPair(
      symbol: json['symbol'],
      currentPrice: json['price'],
      change: json['change'],
      percentChange: json['percent_change'],
    );
  }
  static ForexPair generateModel(String tickerSymbol, dynamic json) {
    return ForexPair(
      symbol: json['symbol'],
      currentPrice: json['price'].toDouble() as double,
      change: json['change'].toDouble() as double,
      percentChange: json['percent_change'].toDouble() as double,
    );
  }
}
