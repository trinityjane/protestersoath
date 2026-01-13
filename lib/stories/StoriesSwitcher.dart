import 'package:flutter/cupertino.dart';
import 'package:protestersoath/stories/rss_page.dart';
import 'package:protestersoath/stories/story_page.dart';

class StoriesSwitcher extends StatelessWidget {
  StoriesSwitcher();

  // Removed PrefService and easy_localization. Use a constructor argument or another state management solution if needed.
  final String storiesMode = "stories"; // Default to 'stories'.

  @override
  Widget build(BuildContext context) {
    // If you want to switch to feeds, change storiesMode to "feeds" or use a state management solution.
    if (storiesMode == "feeds") {
      return RSSReader(which: 'Stories', title: 'Stories');
    } else {
      return StoryPage();
    }
  }
}
