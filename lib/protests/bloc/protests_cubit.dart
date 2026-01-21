import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../stories/FeedModel.dart';
import './protests_state.dart';

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
      which = (which + 1) % protests;
      // TODO: Replace with actual localization logic
      var index = which.toString().padLeft(2, '0');
      var title = 'Protest Title $index';
      var summary = 'Protest Summary $index';
      var body = 'Protest Body $index';
      var date = 'Protest Date $index';
      var credit = 'Protest Credit $index';
      var image = 'assets/img/protester.png';
      var postURL = 'https://example.com/protest_$index';
      var referenceURL = 'https://example.com/protest_$index';
      final protest = FeedModel(
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
      emit(LoadedState(protest));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
