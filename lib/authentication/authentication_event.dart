import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  const AppStarted();
  @override
  String toString() => 'AppStarted';
  @override
  List<Object> get props => [];
}

class LoginReasonPageEvent extends AuthenticationEvent {
  const LoginReasonPageEvent();
  @override
  String toString() => 'LoginReasonPage';
  @override
  List<Object> get props => [];
}

class LoginPrivacyPageEvent extends AuthenticationEvent {
  const LoginPrivacyPageEvent();
  @override
  String toString() => 'LoginPrivacyPage';
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String phoneNumber;
  const LoggedIn({required this.phoneNumber});
  @override
  String toString() => 'LoggedIn { phoneNumber: $phoneNumber }';
  @override
  List<Object> get props => [phoneNumber];
}

class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
  @override
  String toString() => 'LoggedOut';
  @override
  List<Object> get props => [];
}
