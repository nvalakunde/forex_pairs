import 'package:equatable/equatable.dart';
import '../../models/forex_pair.dart';

abstract class ForexState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForexInitial extends ForexState {}

class ForexLoading extends ForexState {}

class ForexLoaded extends ForexState {
  final List<ForexPair> forexPairs;

  ForexLoaded(this.forexPairs);

  @override
  List<Object> get props => [forexPairs];
}

class ForexError extends ForexState {
  final String message;

  ForexError(this.message);

  @override
  List<Object> get props => [message];
}
