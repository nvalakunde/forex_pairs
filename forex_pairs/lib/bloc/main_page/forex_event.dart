import 'package:equatable/equatable.dart';

abstract class ForexEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadForexPairs extends ForexEvent {}

class RefreshForexPairs extends ForexEvent {}
