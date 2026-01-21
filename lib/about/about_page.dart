import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_event.dart';

import '../settings/SettingsContainer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double height = MediaQuery.of(context).size.height - appBarHeight;
    double textHeight = height * 0.75;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape && height > 550) {
      textHeight = 150;
    }
    if (!isLandscape && height > 550) {
      textHeight = height * 0.5;
    }
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer =
            menuConfig == 'allScreens' || menuConfig == 'homeOnly';
        final bool showBack =
            (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');
        return WillPopScope(
          onWillPop: () async {
            if (showBack && menuConfig != 'allScreens') {
              Navigator.of(context).popUntil((route) => route.isFirst);
              return false;
            }
            return true;
          },
          child: Scaffold(
            drawer:
                showDrawer && menuConfig != 'buttonsOnly' ? AppDrawer() : null,
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.about,
                style: TextStyle(color: Colors.white),
              ),
              leading: (showBack && menuConfig != 'allScreens')
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        BlocProvider.of<AppDrawerBloc>(context)
                            .add(HomePageEvent());
                      },
                    )
                  : null,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                  itemExtent: textHeight,
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          AppLocalizations.of(context)!.reason0,
                          textScaleFactor: 1.3,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverGrid.count(
                  crossAxisCount: 2,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/img/trinityjane.jpg'),
                                )))),
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(
                                      'assets/img/logo_flutter_transparent.png'),
                                )))),
                  ],
                ),
                SliverGrid.count(
                  crossAxisCount: 2,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Made by 3Jane',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Powered by Flutter',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
