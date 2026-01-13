import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:protestersoath/data/Protester.dart';
import './login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String verID = "";

  LoginBloc() : super(InitialLoginState()) {
    on<AppStartEvent>((event, emit) => emit(InitialLoginState()));
    on<SendOtpEvent>((event, emit) async {
      emit(LoadingState());
      final Protester user = Protester(phoneNumber: event.phoNo);
      emit(LoginCompleteState(user));
    });
    on<LoginExceptionEvent>((event, emit) => emit(ExceptionState(message: event.message)));
  }

  @override
  void onEvent(LoginEvent event) {
    super.onEvent(event);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
