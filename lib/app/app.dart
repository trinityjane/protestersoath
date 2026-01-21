import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/home/home_page.dart';
import 'package:protestersoath/login/LoginPage.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/oath/VerifyPage.dart';
import 'package:protestersoath/oath/VerifyProofOfOathPage.dart';
import 'package:protestersoath/privacy/privacy_page.dart';
import 'package:protestersoath/protests/ProtestsSwitcher.dart';
import 'package:protestersoath/protests/bloc/protests_cubit.dart';
import 'package:protestersoath/reason/reason_page.dart';
import 'package:protestersoath/settings/settings_page.dart';
import 'package:protestersoath/splash/splash_page.dart';
import 'package:protestersoath/stories/StoriesSwitcher.dart';
import 'package:protestersoath/stories/bloc/stories_cubit.dart';
import 'package:protestersoath/utils/onBackPressed.dart';

import '../about/about_page.dart';
import '../navigation/app_drawer/app_drawer_event.dart';
import '../navigation/app_drawer/app_drawer_state.dart';
import '../oath/oath_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Restore normal login flow, but pass hardcodedPhone to AppView if authenticated
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Unauthenticated) {
          return LoginPage();
        } else if (state is LoginReasonPageState) {
          return ReasonPage(true);
        } else if (state is LoginPrivacyPageState) {
          return PrivacyPage(true);
        } else if (state is Authenticated) {
          // Pass the authenticated phone number to AppView
          final phone = state.phoneNumber;
          return AppView(hardcodedPhone: phone);
        } else {
          return SplashPage();
        }
      },
    );
  }
}

class AppView extends StatefulWidget {
  final String? hardcodedPhone;
  AppView({this.hardcodedPhone});
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  AppDrawerState state = LoadingState();

  Future<bool> _onBackPressed() {
    return onBackPressed(context, false, state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppDrawerBloc>(
      create: (context) => AppDrawerBloc(
        hardcodedPhone: widget.hardcodedPhone,
      ),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await _onBackPressed();
          }
        },
        child: BlocBuilder<AppDrawerBloc, AppDrawerState>(
          builder: (context, state) {
            this.state = state;
            if (state is LoadingState) {
              BlocProvider.of<AppDrawerBloc>(context).add(LoadingEvent());
              return SplashPage();
            }
            if (state is AboutPageState) {
              return AboutPage();
            } else if (state is HomePageState) {
              return HomePage();
            } else if (state is SettingsPageState) {
              return SettingsPage();
            } else if (state is StoryPageState) {
              return BlocProvider<StoriesCubit>(
                create: (context) => StoriesCubit(),
                child: StoriesSwitcher(),
              );
            } else if (state is ProtestPageState) {
              return BlocProvider<ProtestsCubit>(
                create: (context) => ProtestsCubit(),
                child: ProtestsSwitcher(),
              );
            } else if (state is OathPageState) {
              return OathPage();
            } else if (state is ReasonPageState) {
              return ReasonPage(false);
            } else if (state is PrivacyPageState) {
              return PrivacyPage(false);
            } else if (state is VerifyPageState) {
              return VerifyPage();
            } else if (state is VerifyProofOfOathState) {
              return VerifyProofOfOathPage();
            } else {
              return SplashPage();
            }
          },
        ),
      ),
    );
  }
}
