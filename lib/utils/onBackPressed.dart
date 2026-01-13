import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

Future<bool> onBackPressed(BuildContext context, bool isLogin, dynamic state) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.areYouSure),
      content: Text(AppLocalizations.of(context)!.exitAppPrompt),
      actions: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.no),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.yes),
        ),
      ],
    ),
  );
  return result ?? false;
}
