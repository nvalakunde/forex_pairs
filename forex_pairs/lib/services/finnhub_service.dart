import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forex_pairs/constants/app_constants.dart';
import 'package:forex_pairs/models/historical_data.dart';

import '../models/forex_pair.dart';
import 'package:http/http.dart' as http;

abstract class FinnhubService {
  Future<List<ForexPair>> fetchForexPairs();
  Future<TradeHistoryData> fetchHistoricalData(
      String symbol, String resolution);
}

class FinnhubServiceImpl implements FinnhubService {
  late http.Client httpClient;
  @override
  Future<List<ForexPair>> fetchForexPairs() async {
    try {
      httpClient = http.Client();
      var searchString = _trimAndUppercaseString("USD");
      final apiRequestUrl = Uri.https(
          AppConstants.baseUrl,
          '${AppConstants.basePath}rates',
          {'base': searchString, 'token': AppConstants.finHubAPIKey});
      final apiResponse = await httpClient
          .get(apiRequestUrl, headers: {"token": AppConstants.finHubAPIKey});
      if (apiResponse.statusCode != 200) {
        return [
          ForexPair(
            symbol: 'EUR/USD',
            currentPrice: 1.1234,
            change: 0.0005,
            percentChange: 0.04,
          ),
          ForexPair(
            symbol: 'GBP/USD',
            currentPrice: 1.2345,
            change: -0.0003,
            percentChange: -0.02,
          ),
        ];
      }
      final apiResponseJson = jsonDecode(apiResponse.body);
      return [ForexPair.generateModel(searchString, apiResponseJson)];
    } catch (e) {
      debugPrint("fetch forex :: $e");
      return [];
    }
    // For now, returning mock data
  }

  String _trimAndUppercaseString(String inputString) {
    String resultString = '';
    resultString = inputString.trim().toUpperCase();
    return resultString;
  }

  @override
  Future<TradeHistoryData> fetchHistoricalData(
      String symbol, String resolution) async {
    try {
      httpClient = http.Client();
      final apiRequestUrl =
          Uri.https(AppConstants.baseUrl, '${AppConstants.basePath}candle', {
        'symbol': symbol,
        'resolution': resolution,
        'from':
            "${DateTime.now().subtract(Duration(minutes: 5)).millisecondsSinceEpoch}",
        'to': "${DateTime.now().millisecondsSinceEpoch}",
      });

      final apiResponse = await httpClient.get(apiRequestUrl, headers: {
        "token": AppConstants.finHubAPIKey,
      });
      if (apiResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(apiResponse.body);
        return TradeHistoryData.fromJson(data);
      } else {
        final Map<String, dynamic> data = {
          "c": [1.10713, 1.10288, 1.10397, 1.10182],
          "h": [1.1074, 1.10751, 1.10729, 1.10595],
          "l": [1.09897, 1.1013, 1.10223, 1.10101],
          "o": [1.0996, 1.107, 1.10269, 1.10398],
          "s": "ok",
          "t": [1568667600, 1568754000, 1568840400, 1568926800],
          "v": [75789, 75883, 73485, 5138]
        };
        return TradeHistoryData.fromJson(data);
        throw Exception('Failed to load historical data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
