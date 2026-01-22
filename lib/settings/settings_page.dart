import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SettingsContainer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage();

  // Drawer visibility logic can be managed via state or passed as a parameter if needed.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer =
            menuConfig == 'allScreens' || menuConfig == 'homeOnly';
        final bool showBack =
            (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');
        return FutureBuilder<bool>(
          future: SettingsContainer.getMenuBackOpensDrawer(),
          builder: (context, backOpensDrawerSnapshot) {
            final bool backOpensDrawer = backOpensDrawerSnapshot.data ?? false;
            return WillPopScope(
              onWillPop: () async {
                if (menuConfig != 'buttonsOnly' && menuConfig != 'allScreens') {
                  if (backOpensDrawer) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('openDrawerOnHome', true);
                  }
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
                return false;
              },
              child: Scaffold(
                drawer: showDrawer && menuConfig != 'buttonsOnly'
                    ? AppDrawer()
                    : null,
                appBar: AppBar(
                  backgroundColor: Colors.grey,
                  title: Text(
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: (showBack && menuConfig != 'allScreens')
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () async {
                            if (menuConfig != 'buttonsOnly' &&
                                menuConfig != 'allScreens') {
                              final prefs =
                                  await SharedPreferences.getInstance();
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
                body: SettingsContainer(),
              ),
            );
          },
        );
      },
    );
  }
}
