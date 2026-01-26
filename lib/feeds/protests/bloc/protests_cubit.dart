import 'package:flutter_bloc/flutter_bloc.dart';

import '../../FeedModel.dart';
import 'protests_state.dart';

class ProtestsCubit extends Cubit<ProtestsState> {
  ProtestsCubit() : super(InitialState()) {
    getNextProtest();
  }

  final int protests = 6;
  static int which = -1;

  String fn(String? string) {
    return string == null || string.startsWith("STORY_") ? '' : string;
  }

  void getNextProtest() async {
    try {
      emit(LoadingState());
      // Generate a mock list of protests for demonstration
      List<FeedModel> protestsList = List.generate(14, (i) {
        var index = i.toString().padLeft(2, '0');
        var title = 'Protest Title $index';
        var summary = 'Protest Summary $index';
        var body = 'Protest Body $index';
        var date = '2026-01-2${i % 9 + 1}';
        var credit = 'Protest Credit $index';
        var image = 'assets/img/protester.png';
        var postURL = 'https://example.com/protest_$index';
        var referenceURL = 'https://example.com/protest_$index';
        return FeedModel(
          date: fn(date),
          title: fn(title),
          summary: fn(summary),
          body: fn(body),
          credit: fn(credit),
          imageURL: fn(image),
          referenceURL: fn(referenceURL),
          postURL: fn(postURL),
          isHTML: false,
        );
      });
      emit(LoadedState(protestsList));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
