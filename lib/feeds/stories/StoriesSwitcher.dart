import 'package:flutter/cupertino.dart';
import 'package:protestersoath/feeds/feed_page.dart';
import 'package:protestersoath/feeds/stories/story_page.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/settings/SettingsContainer.dart';

class StoriesSwitcher extends StatelessWidget {
  final bool fromButton;
  StoriesSwitcher({this.fromButton = false});

  Future<String> _getStoriesConfig() async {
    return await SettingsContainer.getStoriesConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getStoriesConfig(),
      builder: (context, snapshot) {
        final storiesConfig = snapshot.data ?? 'installed';
        if (storiesConfig == 'rss') {
          return RSSReader(
            which: 'Stories',
            title:
                AppLocalizations.of(context)?.stories ?? 'Stories of Protest',
            fromButton: fromButton,
          );
        } else {
          return StoryPage(fromButton: fromButton);
        }
      },
    );
  }
}
