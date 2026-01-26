import 'package:flutter/cupertino.dart';
import 'package:protestersoath/feeds/feed_page.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

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
