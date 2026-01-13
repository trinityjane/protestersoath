import 'package:bloc/bloc.dart';
import './authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(InitialAuthenticationState()) {
    on<AppStarted>((event, emit) async {
      // TODO: Replace with secure storage or another persistence solution if needed.
      // For now, always start unauthenticated for stateless Flutter 3 compatibility.
      emit(Unauthenticated());
    });
    on<LoggedIn>((event, emit) async {
      emit(Loading());
      emit(Authenticated());
    });
    on<LoggedOut>((event, emit) async {
      emit(Loading());
      emit(Unauthenticated());
    });
    on<LoginReasonPageEvent>((event, emit) => emit(LoginReasonPageState()));
    on<LoginPrivacyPageEvent>((event, emit) => emit(LoginPrivacyPageState()));
  }
}
