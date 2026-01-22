import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation/app_drawer/app_drawer.dart';
import 'PrivacyContainer.dart';

class PrivacyPage extends StatelessWidget {
  final bool isLogin;
  PrivacyPage(this.isLogin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text(
            AppLocalizations.of(context)!.privacyTitle,
            style: TextStyle(color: Colors.white),
          ),
          // No back arrow in login flow
          leading: null,
        ),
        body: Column(
          children: [
            Expanded(child: PrivacyContainer()),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Acknowledge'),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/oath');
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return FutureBuilder<String>(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('menuConfig') ?? 'homeOnly'),
        builder: (context, snapshot) {
          final menuConfig = snapshot.data ?? 'homeOnly';
          final bool showBack =
              (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');
          return BlocBuilder<AppDrawerBloc, AppDrawerState>(
            builder: (BuildContext context, AppDrawerState state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey,
                  title: Text(
                    AppLocalizations.of(context)!.privacyTitle,
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () async {
                      if (menuConfig != 'buttonsOnly') {
                        final prefs = await SharedPreferences.getInstance();
                        final menuBackOpensDrawer =
                            prefs.getBool('menuBackOpensDrawer') ?? false;
                        if (menuBackOpensDrawer) {
                          await prefs.setBool('openDrawerOnHome', true);
                        }
                      }
                      BlocProvider.of<AppDrawerBloc>(context)
                          .add(HomePageEvent());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
                body: PrivacyContainer(),
              );
            },
          );
        },
      );
    }
  }
}
