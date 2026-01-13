import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

import 'FeedModel.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(InitialState());

  final int stories = 6;
  static int which = -1;

  String fn(String? string) {
    return string == null || string.startsWith("STORY_") ? '' : string;
  }

  void getNextStory(BuildContext context) async {
    try {
      emit(LoadingState());
      which = (which + 1) % stories;
      final l10n = AppLocalizations.of(context)!;
      var index = which.toString().padLeft(2, '0');
      String title, summary, body, date, credit, image, postURL, referenceURL;
      switch (which) {
        case 0:
          title = l10n.storyTitle00;
          summary = '';
          body = l10n.story00;
          date = l10n.storyDate00;
          credit = l10n.storyCredit00;
          image = l10n.storyImage00;
          postURL = l10n.storyUrl00;
          referenceURL = l10n.storyUrl00;
          break;
        case 1:
          title = l10n.storyTitle01;
          summary = l10n.storySummary01;
          body = l10n.story01;
          date = l10n.storyDate01;
          credit = l10n.storyCredit01;
          image = l10n.storyImage01;
          postURL = l10n.storyUrl01;
          referenceURL = l10n.storyUrl01;
          break;
        case 2:
          title = l10n.storyTitle02;
          summary = l10n.storySummary02;
          body = l10n.story02;
          date = l10n.storyDate02;
          credit = l10n.storyCredit02;
          image = l10n.storyImage02;
          postURL = l10n.storyUrl02;
          referenceURL = l10n.storyUrl02;
          break;
        case 3:
          title = l10n.storyTitle03;
          summary = l10n.storySummary03;
          body = l10n.story03;
          date = l10n.storyDate03;
          credit = l10n.storyCredit03;
          image = l10n.storyImage03;
          postURL = l10n.storyUrl03;
          referenceURL = l10n.storyUrl03;
          break;
        case 4:
          title = l10n.storyTitle04;
          summary = '';
          body = l10n.story04;
          date = l10n.storyDate04;
          credit = l10n.storyCredit04;
          image = l10n.storyImage04;
          postURL = l10n.storyUrl04;
          referenceURL = l10n.storyUrl04;
          break;
        case 5:
          title = l10n.storyTitle05;
          summary = l10n.storySummary05;
          body = '';
          date = l10n.storyDate05;
          credit = l10n.storyCredit05;
          image = l10n.storyImage05;
          postURL = l10n.storyUrl05;
          referenceURL = l10n.storyUrl05;
          break;
        default:
          title = '';
          summary = '';
          body = '';
          date = '';
          credit = '';
          image = '';
          postURL = '';
          referenceURL = '';
      }
      final story = FeedModel(
        date: date,
        title: title,
        summary: summary,
        body: body,
        credit: credit,
        imageURL: image,
        referenceURL: referenceURL,
        postURL: postURL,
        isHTML: false,
      );
      emit(LoadedState(story));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
