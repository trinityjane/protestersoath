import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AppDrawerEvent extends Equatable {
  const AppDrawerEvent();
  @override
  List<Object> get props => [];
}

class LoadingEvent extends AppDrawerEvent {
  const LoadingEvent() : super();
  @override
  List<Object> get props => [];
}

class HomePageEvent extends AppDrawerEvent {
  const HomePageEvent() : super();
  @override
  String toString() => 'HomePage';
  @override
  List<Object> get props => [];
}

class AboutPageEvent extends AppDrawerEvent {
  const AboutPageEvent() : super();
  @override
  String toString() => 'AboutPage';
  @override
  List<Object> get props => [];
}

class SettingsPageEvent extends AppDrawerEvent {
  const SettingsPageEvent() : super();
  @override
  String toString() => 'SettingsPage';
  @override
  List<Object> get props => [];
}

class StoryPageEvent extends AppDrawerEvent {
  const StoryPageEvent() : super();
  @override
  String toString() => 'StoryPage';
  @override
  List<Object> get props => [];
}

class ProtestPageEvent extends AppDrawerEvent {
  const ProtestPageEvent() : super();
  @override
  String toString() => 'ProtestPage';
  @override
  List<Object> get props => [];
}

class OathPageEvent extends AppDrawerEvent {
  const OathPageEvent() : super();
  @override
  String toString() => 'OathPage';
  @override
  List<Object> get props => [];
}

class ReasonPageEvent extends AppDrawerEvent {
  const ReasonPageEvent() : super();
  @override
  String toString() => 'ReasonPage';
  @override
  List<Object> get props => [];
}

class VerifyPageEvent extends AppDrawerEvent {
  const VerifyPageEvent() : super();
  @override
  String toString() => 'VerifyPage';
  @override
  List<Object> get props => [];
}

class PrivacyPageEvent extends AppDrawerEvent {
  const PrivacyPageEvent() : super();
  @override
  String toString() => 'PrivacyPage';
  @override
  List<Object> get props => [];
}

class ReasonBackButtonEvent extends AppDrawerEvent {
  final AppDrawerEvent toPageEvent;
  const ReasonBackButtonEvent(this.toPageEvent) : super();
  @override
  String toString() => 'ReasonBackButton';
  @override
  List<Object> get props => [toPageEvent];
}

class PrivacyBackButtonEvent extends AppDrawerEvent {
  final AppDrawerEvent toPageEvent;
  const PrivacyBackButtonEvent(this.toPageEvent) : super();
  @override
  String toString() => 'PrivacyBackButton';
  @override
  List<Object> get props => [toPageEvent];
}

class BackButtonEvent extends AppDrawerEvent {
  final String fromPage;
  const BackButtonEvent(this.fromPage) : super();
  @override
  String toString() => 'BackButton';
  @override
  List<Object> get props => [fromPage];
}

class VerifyProofOfOathEvent extends AppDrawerEvent {
  final String othersPhone;
  const VerifyProofOfOathEvent({required this.othersPhone}) : super();
  @override
  String toString() => 'VerifyProofOfOath { othersPhone: $othersPhone }';
  @override
  List<Object> get props => [othersPhone];
}
