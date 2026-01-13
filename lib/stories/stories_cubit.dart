import 'package:flutter_bloc/flutter_bloc.dart';
import 'FeedModel.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(InitialState()) {
    getNextStory();
  }

  final int stories = 6;
  static int which = -1;

  String fn(String? string) {
    return string == null || string.startsWith("STORY_") ? '' : string;
  }

  void getNextStory() async {
    try {
      emit(LoadingState());
      which = (which + 1) % stories;
      // Use the correct asset file names (story000.jpg, story001.jpg, ...)
      var index = which.toString().padLeft(3, '0');
      var title = 'Story Title $index';
      var summary = 'Story Summary $index';
      var body = 'Story Body $index';
      var date = 'Story Date $index';
      var credit = 'Story Credit $index';
      var image = 'assets/img/stories/story$index.jpg';
      var postURL = 'https://example.com/story$index';
      var referenceURL = 'https://example.com/story$index';
      final story = FeedModel(
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
      emit(LoadedState(story));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
