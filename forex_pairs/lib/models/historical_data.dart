class TradeHistoryData {
  final List<double> close;
  final List<double> high;
  final List<double> low;
  final List<double> open;
  final List<int> timestamps;
  final List<int> volume;

  TradeHistoryData({
    required this.close,
    required this.high,
    required this.low,
    required this.open,
    required this.timestamps,
    required this.volume,
  });

  factory TradeHistoryData.fromJson(Map<String, dynamic> json) {
    return TradeHistoryData(
      close: List<double>.from(json['c']),
      high: List<double>.from(json['h']),
      low: List<double>.from(json['l']),
      open: List<double>.from(json['o']),
      timestamps: List<int>.from(json['t']),
      volume: List<int>.from(json['v']),
    );
  }
}
