import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_event.dart';
import 'package:protestersoath/oath/OathContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/SettingsContainer.dart';

class OathPage extends StatelessWidget {
  final bool fromButton;
  const OathPage({Key? key, this.fromButton = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer =
            (menuConfig == 'allScreens' || menuConfig == 'homeOnly') &&
                !fromButton;
        final bool showBack =
            (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly') ||
                (menuConfig == 'allScreens' && fromButton);
        return WillPopScope(
          onWillPop: () async {
            if (menuConfig != 'buttonsOnly' && menuConfig != 'allScreens') {
              final prefs = await SharedPreferences.getInstance();
              final menuBackOpensDrawer =
                  prefs.getBool('menuBackOpensDrawer') ?? false;
              if (menuBackOpensDrawer) {
                await prefs.setBool('openDrawerOnHome', true);
              }
            }
            Navigator.of(context).popUntil((route) => route.isFirst);
            return false;
          },
          child: Scaffold(
            drawer:
                showDrawer && menuConfig != 'buttonsOnly' ? AppDrawer() : null,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.theoath,
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
            body: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // A flexible child that will grow to fit the viewport but
                            // still be at least as big as necessary to fit its contents.
                            child: Container(
                              color: Colors.grey[100],
                              height: 18.0,
                              alignment: Alignment.center,
                              child: TheOath(false, viewportConstraints),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ); // <-- This closes SingleChildScrollView
              },
            ),
          ),
        );
      },
    );
  }
}
