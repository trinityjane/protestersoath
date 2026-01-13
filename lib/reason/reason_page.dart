import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import '../navigation/app_drawer/appdrawer_state.dart';
import 'ReasonContainer.dart';

class ReasonPage extends StatelessWidget {
  final bool isLogin;
  final String? drawer;

  ReasonPage(this.isLogin, {Key? key, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use InheritedWidget or Provider for drawer state if needed, or pass as param
    final String? effectiveDrawer = drawer;
    if (isLogin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.thereason,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ),
        body: TheReason(),
      );
    } else {
      return BlocBuilder<AppDrawerBloc, AppDrawerState>(
        builder: (BuildContext context, AppDrawerState state) {
          return Scaffold(
            drawer: effectiveDrawer == 'all' ? AppDrawer() : null,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.thereason,
                style: TextStyle(color: Colors.white),
              ),
              leading: effectiveDrawer == 'all'
                  ? null
                  : IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        final lastPage = (state is ReasonPageState) ? state.lastPage : null;
                        if (lastPage != null) {
                          BlocProvider.of<AppDrawerBloc>(context)
                              .add(ReasonBackButtonEvent(lastPage));
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                    ),
            ),
            body: TheReason(),
          );
        },
      );
    }
  }
}
