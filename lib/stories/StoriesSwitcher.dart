import 'package:flutter/cupertino.dart';
import 'package:protestersoath/settings/SettingsContainer.dart';
import 'package:protestersoath/stories/rss_page.dart';
import 'package:protestersoath/stories/story_page.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class StoriesSwitcher extends StatelessWidget {
  StoriesSwitcher();

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
            title: AppLocalizations.of(context)?.stories ?? 'Stories of Protest',
          );
        } else {
          return StoryPage();
        }
      },
    );
  }
}
