import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';

import '../res.dart';

class AboutPage extends StatelessWidget {
  // static Route route() {
  //   return MaterialPageRoute(builder: (_) => AboutPage());
  // }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;

    double height = MediaQuery.of(context).size.height - appBarHeight;
    double textHeight = height * 0.75;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape && height > 550) {
      textHeight = 150;
    }
    // bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (!isLandscape && height > 550 ) {
      textHeight = height * 0.5;
    }
    print(height.toString());
    return Scaffold(
        drawer: null, // Use null for drawer if not needed, or implement another way if required
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(
            "About",
            style: TextStyle(color: Colors.white),
          ),
          leading: null,
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
                              image: AssetImage(Res.trinity),
                            )))),
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(Res.logo_flutter_transparent),
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
        ));
  }
}
