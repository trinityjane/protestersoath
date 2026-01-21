import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            )),
        body: PrivacyContainer(),
      );
    } else {
      return BlocBuilder<AppDrawerBloc, AppDrawerState>(
          builder: (BuildContext context, AppDrawerState state) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.privacyTitle,
                style: TextStyle(color: Colors.white),
              ),
              leading: (() {
                AppDrawerEvent? lastPage =
                    (state is PrivacyPageState) ? state.lastPage : null;
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (lastPage != null) {
                      BlocProvider.of<AppDrawerBloc>(context)
                          .add(PrivacyBackButtonEvent(lastPage));
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                );
              })()),
          body: PrivacyContainer(),
        );
      });
    }
  }
}
