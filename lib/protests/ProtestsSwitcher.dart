import 'package:flutter/cupertino.dart';
import 'package:protestersoath/stories/rss_page.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class ProtestsSwitcher extends StatelessWidget {
  const ProtestsSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RSSReader(
      which: "Protests",
      title: AppLocalizations.of(context)?.protests ?? 'Protests',
    );
  }
}
