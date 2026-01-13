import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class TheReason extends StatelessWidget {
  // App Bar for the Login/Oath.
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(shrinkWrap: false, slivers: <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: RichText(
            overflow: TextOverflow.visible,
            text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.black),
                children: <TextSpan>[
                  // todo: clean this code up!
                  TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      text: AppLocalizations.of(context)!.reasonTitle + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason0 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason1 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason2 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason3 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason4 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason5 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason6 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.reason7 + '\n\n'),
                  TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      text: AppLocalizations.of(context)!.explainTitle + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain1 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain2 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain3 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain4 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain5 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain6 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain7 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain8 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain9 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain10 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain11 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain12 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain13 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain14 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.explain15 + '\n\n'),
                ]),
          ),
        ),
      ),
      // Text('The power of protest is to reveal truth in the face of unjust power through non-violent action.'),
    ]);
  }
}
