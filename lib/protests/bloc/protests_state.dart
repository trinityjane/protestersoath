import 'package:equatable/equatable.dart';

import 'FeedModel.dart';

abstract class ProtestsState extends Equatable {}

class InitialState extends ProtestsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ProtestsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ProtestsState {
  LoadedState(this.protests);

  final List<FeedModel> protests;

  @override
  List<Object> get props => [protests];
}

class ErrorState extends ProtestsState {
  @override
  List<Object> get props => [];
}
