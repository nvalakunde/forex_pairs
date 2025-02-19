import 'package:forex_pairs/models/historical_data.dart';
import 'package:forex_pairs/services/finnhub_service.dart';
import 'package:hive/hive.dart';

class HistoryRepository {
  final FinnhubService apiService;
  // final Box cacheBox = Hive.box('history_cache');

  HistoryRepository(FinnhubServiceImpl finnhubServiceImpl,
      {required this.apiService});

  Future<TradeHistoryData> fetchCachedOrApiData(
      String symbol, String resolution) async {
    final cacheKey = '$symbol-$resolution';

    // if (cacheBox.containsKey(cacheKey)) {
    //   return TradeHistoryData.fromJson(cacheBox.get(cacheKey));
    // }

    final data = await apiService.fetchHistoricalData(symbol, resolution);

    // cacheBox.put(cacheKey, {
    //   'c': data.close,
    //   'h': data.high,
    //   'l': data.low,
    //   'o': data.open,
    //   't': data.timestamps,
    //   'v': data.volume,
    // });

    return data;
  }
}
