import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

import '../navigation/app_drawer.dart';
import '../navigation/app_drawer/appdrawer_bloc.dart';
import '../navigation/app_drawer/appdrawer_event.dart';
import '../navigation/app_drawer/appdrawer_state.dart';
import '../settings/SettingsContainer.dart';
import 'VerifyContainer.dart';

class VerifyPage extends StatelessWidget {
  VerifyPage();

  // static Route route() {
  //   return MaterialPageRoute(builder: (_) => VerifyPage(this.isLogin));
  // }
  // final drawer = PrefService.getString('drawer', ignoreCache: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer = menuConfig == 'allScreens' || menuConfig == 'homeOnly';
        final bool showBack = (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');
        return WillPopScope(
          onWillPop: () async {
            if (showBack && menuConfig != 'allScreens') {
              Navigator.of(context).popUntil((route) => route.isFirst);
              return false;
            }
            return true;
          },
          child: Scaffold(
            drawer: showDrawer && menuConfig != 'buttonsOnly' ? AppDrawer() : null,
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.verifyAnOath,
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
            body: VerifyContainer(),
          ),
        );
      },
    );
  }
}
