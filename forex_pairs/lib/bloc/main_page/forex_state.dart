abstract class ForexState {}

class ForexInitial extends ForexState {}

class ForexPriceUpdate extends ForexState {
  final Map<String, dynamic> priceData;
  ForexPriceUpdate(this.priceData);
}

class ForexDataUpdated extends ForexState {
  final Map<String, dynamic> forexData;
  ForexDataUpdated(this.forexData);
}
