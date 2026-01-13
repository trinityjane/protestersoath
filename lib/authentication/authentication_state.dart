import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String phoneNumber;
  Authenticated(this.phoneNumber);
}

class Unauthenticated extends AuthenticationState {}

class Loading extends AuthenticationState {}

class LoginReasonPageState extends AuthenticationState {
  List<Object> get props => [];
}

class LoginPrivacyPageState extends AuthenticationState {
  List<Object> get props => [];
}