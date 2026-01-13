import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class PrivacyContainer extends StatelessWidget {
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
                      text: AppLocalizations.of(context)!.privacyTitle + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.privacy1 + '\n\n'),
                  TextSpan(text: AppLocalizations.of(context)!.privacy2 + '\n\n'),
                ]),
          ),
        ),
      ),
      // Text('The power of protest is to reveal truth in the face of unjust power through non-violent action.'),
    ]);
  }
}
