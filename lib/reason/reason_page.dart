import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import '../navigation/app_drawer/appdrawer_state.dart';
import 'ReasonContainer.dart';
import '../settings/SettingsContainer.dart';

class ReasonPage extends StatelessWidget {
  final bool isLogin;
  final String? drawer;

  ReasonPage(this.isLogin, {Key? key, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer = menuConfig == 'allScreens' || menuConfig == 'homeOnly';
        final bool showBack = (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');
        return BlocBuilder<AppDrawerBloc, AppDrawerState>(
          builder: (BuildContext context, AppDrawerState state) {
            return Scaffold(
              drawer: showDrawer && menuConfig != 'buttonsOnly' ? AppDrawer() : null,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.thereason,
                  style: TextStyle(color: Colors.white),
                ),
                leading: (showBack && menuConfig != 'allScreens')
                    ? IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          BlocProvider.of<AppDrawerBloc>(context).add(HomePageEvent());
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
