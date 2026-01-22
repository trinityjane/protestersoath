import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_event.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/SettingsContainer.dart';
import 'ReasonContainer.dart';

class ReasonPage extends StatelessWidget {
  final bool isLogin;
  final bool fromButton;
  final String? drawer;

  ReasonPage(this.isLogin, {this.fromButton = false, Key? key, this.drawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer = menuConfig == 'allScreens' && !fromButton;
        final bool showBack = menuConfig == 'allScreens' && fromButton;
        return BlocBuilder<AppDrawerBloc, AppDrawerState>(
          builder: (BuildContext context, AppDrawerState state) {
            return Scaffold(
              drawer: showDrawer && menuConfig != 'buttonsOnly'
                  ? AppDrawer()
                  : null,
              appBar: AppBar(
                backgroundColor: Colors.grey,
                title: Text(
                  AppLocalizations.of(context)!.thereason,
                  style: TextStyle(color: Colors.white),
                ),
                leading: showBack
                    ? IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () async {
                          if (menuConfig != 'buttonsOnly' &&
                              menuConfig != 'allScreens') {
                            final prefs = await SharedPreferences.getInstance();
                            final menuBackOpensDrawer =
                                prefs.getBool('menuBackOpensDrawer') ?? false;
                            if (menuBackOpensDrawer) {
                              await prefs.setBool('openDrawerOnHome', true);
                            }
                          }
                          BlocProvider.of<AppDrawerBloc>(context)
                              .add(HomePageEvent());
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      )
                    : null,
              ),
              body: TheReason(),
            );
          },
        );
      },
    );
  }
}
