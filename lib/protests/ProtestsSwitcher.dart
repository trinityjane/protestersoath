import 'package:flutter/cupertino.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/stories/rss_page.dart';

class ProtestsSwitcher extends StatelessWidget {
  final bool fromButton;
  const ProtestsSwitcher({Key? key, this.fromButton = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RSSReader(
      which: "Protests",
      title: AppLocalizations.of(context)?.protests ?? 'Upcoming Protests',
      fromButton: fromButton,
    );
  }
}
