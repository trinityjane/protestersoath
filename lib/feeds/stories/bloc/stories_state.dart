import 'package:equatable/equatable.dart';

import '../../FeedModel.dart';

abstract class StoriesState extends Equatable {}

class InitialState extends StoriesState {
  @override
  List<Object> get props => [];
}

class LoadingState extends StoriesState {
  @override
  List<Object> get props => [];
}

class LoadedState extends StoriesState {
  LoadedState(this.story);

  final FeedModel story;

  @override
  List<Object> get props => [story];
}

class ErrorState extends StoriesState {
  @override
  List<Object> get props => [];
}
