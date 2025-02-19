import 'package:forex_pairs/models/historical_data.dart';
import 'package:forex_pairs/services/finnhub_service.dart';

class HistoryRepository {
  final FinnhubService apiService;
  // final Box cacheBox = Hive.box('history_cache');

  HistoryRepository(FinnhubServiceImpl finnhubServiceImpl,
      {required this.apiService});

  Future<TradeHistoryData> fetchCachedOrApiData(
      String symbol, String resolution) async {
    final data = await apiService.fetchHistoricalData(symbol, resolution);
    return data;
  }
}
