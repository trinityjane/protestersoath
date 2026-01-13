import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_state.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'SettingsContainer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage();

  // Drawer visibility logic can be managed via state or passed as a parameter if needed.
  final bool showDrawer = true; // Always show drawer for now.

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDrawerBloc, AppDrawerState>(
      builder: (context, state) {
        return Scaffold(
          drawer: showDrawer ? AppDrawer() : null,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(color: Colors.white),
            ),
            leading: showDrawer
                ? null
                : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      BlocProvider.of<AppDrawerBloc>(context)
                          .add(BackButtonEvent("SettingsPage"));
                    },
                  ),
          ),
          body: SettingsContainer(),
        );
      },
    );
  }
}
