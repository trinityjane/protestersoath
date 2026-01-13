import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/oath/OathContainer.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import '../settings/SettingsContainer.dart';

class OathPage extends StatelessWidget {
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
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.theoath,
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
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
