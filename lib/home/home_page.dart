import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_state.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'ShapesPainter.dart';
import '../settings/SettingsContainer.dart';
import 'package:protestersoath/camera/camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'allScreens';
        final bool showAllButtons = menuConfig == 'buttonsOnly';
        return BlocBuilder<AppDrawerBloc, AppDrawerState>(
          builder: (BuildContext context, AppDrawerState state) {
            return Scaffold(
              drawer: (menuConfig == 'homeOnly' || menuConfig == 'allScreens') ? AppDrawer() : null,
              appBar: AppBar(
                backgroundColor: Colors.grey,
                title: Text(
                  AppLocalizations.of(context)!.home,
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: IconButton(
                      icon: Icon(Icons.announcement, size: 25),
                      onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(ProtestPageEvent()),
                      tooltip: AppLocalizations.of(context)!.protests,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: IconButton(
                      icon: Icon(Icons.art_track, size: 35),
                      onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(StoryPageEvent()),
                      tooltip: AppLocalizations.of(context)!.stories,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: IconButton(
                      icon: const Icon(Icons.videocam, size: 30),
                      tooltip: 'Camera',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CameraPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size.infinite,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                    ),
                    painter: state is HomePageState ? ShapesPainter(state.token.phoneNumber) : null,
                  ),
                  // Always show left/right bottom buttons
                  Container(
                    alignment: Alignment(0.9, 0.91),
                    child: IconButton(
                      icon: Icon(Icons.list, color: Colors.black, size: 30),
                      tooltip: AppLocalizations.of(context)!.theoath,
                      onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(OathPageEvent()),
                    ),
                  ),
                  Container(
                    alignment: Alignment(-.9, 0.91),
                    child: IconButton(
                      icon: Icon(Icons.privacy_tip, color: Colors.black, size: 30),
                      tooltip: AppLocalizations.of(context)!.privacy,
                      onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(PrivacyPageEvent()),
                    ),
                  ),
                  // Show extra bottom buttons only in buttonsOnly mode
                  if (showAllButtons) ...[
                    Container(
                      alignment: Alignment(-0.45, 0.91),
                      child: IconButton(
                        icon: Icon(Icons.open_in_full, color: Colors.black, size: 30),
                        tooltip: AppLocalizations.of(context)!.verifyButton,
                        onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(VerifyPageEvent()),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.0, 0.91),
                      child: IconButton(
                        icon: Icon(Icons.settings, color: Colors.black, size: 30),
                        tooltip: AppLocalizations.of(context)!.settings,
                        onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(SettingsPageEvent()),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.45, 0.91),
                      child: IconButton(
                        icon: Icon(Icons.group, color: Colors.black, size: 30),
                        tooltip: AppLocalizations.of(context)!.about,
                        onPressed: () => BlocProvider.of<AppDrawerBloc>(context).add(AboutPageEvent()),
                      ),
                    ),
                  ],
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment(0.0, 0.72),
                      child: Text(
                        AppLocalizations.of(context)!.oathTaken,
                        textScaler: TextScaler.linear(1.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
