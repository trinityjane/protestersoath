import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:protestersoath/data/Token.dart';

import 'app_drawer_event.dart';

@immutable
abstract class AppDrawerState extends Equatable {}

class LoadingState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class HomePageState extends AppDrawerState {
  final Token token;
  HomePageState(this.token);
  @override
  List<Object> get props => [token];
}

class AboutPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class StoryPageState extends AppDrawerState {
  final bool fromButton;
  StoryPageState({this.fromButton = false});
  @override
  List<Object> get props => [fromButton];
}

class ProtestPageState extends AppDrawerState {
  final bool fromButton;
  ProtestPageState({this.fromButton = false});
  @override
  List<Object> get props => [fromButton];
}

class VerifyPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class ReasonPageState extends AppDrawerState {
  final bool fromButton;
  ReasonPageState(this.fromButton);
  @override
  List<Object> get props => [fromButton];
}

class PrivacyPageState extends AppDrawerState {
  final AppDrawerEvent lastPage;
  PrivacyPageState(this.lastPage);
  @override
  List<Object> get props => [lastPage];
}

class OathPageState extends AppDrawerState {
  final bool fromButton;
  OathPageState({this.fromButton = false});
  @override
  List<Object> get props => [fromButton];
}

class SettingsPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class VerifyProofOfOathState extends AppDrawerState {
  final String othersPhone;
  VerifyProofOfOathState(this.othersPhone);
  @override
  List<Object> get props => [othersPhone];
}
