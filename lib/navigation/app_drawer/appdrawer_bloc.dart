import 'dart:async';
import 'package:protestersoath/data/Token.dart';
import 'package:bloc/bloc.dart';
import './appdrawer.dart';

class AppDrawerBloc extends Bloc<AppDrawerEvent, AppDrawerState> {
  late Token token;
  late String othersPhone;
  late AppDrawerEvent lastPage;
  late AppDrawerEvent currentPage;

  AppDrawerBloc() : super(LoadingState()) {
    on<LoadingEvent>((event, emit) async {
      // In Flutter 3, remove FlutterSession and use a stateless approach or another persistence solution.
      // For now, just yield a default HomePageState with a placeholder token.
      token = Token(uid: '', phoneNumber: '');
      emit(HomePageState(token));
    });
    on<HomePageEvent>((event, emit) async {
      token = Token(uid: '', phoneNumber: '');
      emit(HomePageState(token));
    });
    on<AboutPageEvent>((event, emit) => emit(AboutPageState()));
    on<SettingsPageEvent>((event, emit) => emit(SettingsPageState()));
    on<StoryPageEvent>((event, emit) => emit(StoryPageState()));
    on<ProtestPageEvent>((event, emit) => emit(ProtestPageState()));
    on<VerifyPageEvent>((event, emit) => emit(VerifyPageState()));
    on<OathPageEvent>((event, emit) => emit(OathPageState()));
    on<ReasonPageEvent>((event, emit) => emit(ReasonPageState(lastPage)));
    on<PrivacyPageEvent>((event, emit) => emit(PrivacyPageState(lastPage)));
    on<VerifyProofOfOathEvent>((event, emit) => emit(VerifyProofOfOathState(event.othersPhone)));
    on<BackButtonEvent>((event, emit) async {
      token = Token(uid: '', phoneNumber: '');
      emit(HomePageState(token));
    });
    on<ReasonBackButtonEvent>((event, emit) async {
      emit(LoadingState());
      await for (final e in backFromReason(event.toPageEvent)) {
        add(e);
      }
    });
    on<PrivacyBackButtonEvent>((event, emit) async {
      emit(LoadingState());
      await for (final e in backFromReason(event.toPageEvent)) {
        add(e);
      }
    });
  }

  Stream<AppDrawerEvent> backFromReason(event) async* {
    yield event;
  }
}
