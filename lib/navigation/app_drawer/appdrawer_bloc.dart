import 'dart:async';
import 'package:protestersoath/data/Token.dart';
import 'package:bloc/bloc.dart';
import './appdrawer.dart';

class AppDrawerBloc extends Bloc<AppDrawerEvent, AppDrawerState> {
  late Token token;
  late String othersPhone;
  late AppDrawerEvent lastPage = HomePageEvent();
  late AppDrawerEvent currentPage;
  final String? hardcodedPhone;

  AppDrawerBloc({this.hardcodedPhone}) : super(LoadingState()) {
    on<LoadingEvent>((event, emit) async {
      // Use hardcoded phone if provided
      token = Token(uid: '', phoneNumber: hardcodedPhone ?? '');
      emit(HomePageState(token));
    });
    on<HomePageEvent>((event, emit) async {
      token = Token(uid: '', phoneNumber: hardcodedPhone ?? '');
      emit(HomePageState(token));
    });
    on<AboutPageEvent>((event, emit) => emit(AboutPageState()));
    on<SettingsPageEvent>((event, emit) => emit(SettingsPageState()));
    on<StoryPageEvent>((event, emit) => emit(StoryPageState()));
    on<ProtestPageEvent>((event, emit) => emit(ProtestPageState()));
    on<VerifyPageEvent>((event, emit) => emit(VerifyPageState()));
    on<OathPageEvent>((event, emit) => emit(OathPageState()));
    on<ReasonPageEvent>((event, emit) {
      // If lastPage is not set, default to HomePageEvent
      if (!isSet(lastPage)) {
        lastPage = HomePageEvent();
      }
      emit(ReasonPageState(lastPage));
    });
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

// Helper to check if lastPage is set
bool isSet(AppDrawerEvent? event) {
  try {
    return event != null;
  } catch (_) {
    return false;
  }
}
