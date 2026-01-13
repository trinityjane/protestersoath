import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

import 'MenuItem.dart';
import 'app_drawer/appdrawer_bloc.dart';
import 'app_drawer/appdrawer_event.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 52),
                children: <Widget>[
                  MenuItem(AppLocalizations.of(context)!.home, Icons.turned_in, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(HomePageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.verifyOther, Icons.open_in_full, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(VerifyPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.theOath, Icons.list, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(OathPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.theReason, Icons.info, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(ReasonPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.stories, Icons.art_track, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(StoryPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.protests, Icons.announcement, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(ProtestPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.settings, Icons.settings, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(SettingsPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.about, Icons.group, () {
                    BlocProvider.of<AppDrawerBloc>(context).add(AboutPageEvent());
                    Navigator.pop(context);
                  }),
                  MenuItem(AppLocalizations.of(context)!.logout, Icons.exit_to_app, () {
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
