import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:protestersoath/data/Token.dart';

import 'appdrawer_event.dart';

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
  @override
  List<Object> get props => [];
}

class ProtestPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class VerifyPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
}

class ReasonPageState extends AppDrawerState {
  final AppDrawerEvent lastPage;
  ReasonPageState(this.lastPage);
  @override
  List<Object> get props => [lastPage];
}
class PrivacyPageState extends AppDrawerState {
  final AppDrawerEvent lastPage;
  PrivacyPageState(this.lastPage);
  @override
  List<Object> get props => [lastPage];
}
class OathPageState extends AppDrawerState {
  @override
  List<Object> get props => [];
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
