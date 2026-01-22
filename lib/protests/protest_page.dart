import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_state.dart';
import 'package:protestersoath/protests/ProtestRSSCard.dart';
import 'package:protestersoath/protests/bloc/protests_cubit.dart';
import 'package:protestersoath/protests/bloc/protests_state.dart'
    as protests_states;
import 'package:shared_preferences/shared_preferences.dart';

class ProtestPage extends StatefulWidget {
  const ProtestPage({Key? key}) : super(key: key);

  @override
  _ProtestPageState createState() => _ProtestPageState();
}

class _ProtestPageState extends State<ProtestPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('menuConfig') ?? 'allScreens'),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'allScreens';
        return BlocBuilder<ProtestsCubit, protests_states.ProtestsState>(
          builder: (context, state) {
            // Get fromButton from AppDrawerBloc/AppDrawerState
            final appDrawerState = context.read<AppDrawerBloc>().state;
            bool fromButton = false;
            if (appDrawerState is ProtestPageState) {
              fromButton = appDrawerState.fromButton;
            }
            final bool showDrawer = menuConfig == 'allScreens' && !fromButton;
            final bool showBack = menuConfig == 'allScreens' && fromButton;
            if (state is protests_states.LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is protests_states.ErrorState) {
              return const Center(child: Icon(Icons.close));
            } else if (state is protests_states.LoadedState) {
              return Scaffold(
                drawer: showDrawer ? const AppDrawer() : null,
                body: Container(
                  color: Colors.grey,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        title: Text(
                          AppLocalizations.of(context)!.protests,
                          style: const TextStyle(color: Colors.white),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.art_track, size: 40),
                            onPressed: () =>
                                context.read<ProtestsCubit>().getNextProtest(),
                          ),
                        ],
                        leading: showBack
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                              )
                            : null,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          state.protests
                              .map((protest) =>
                                  ProtestRSSCard(context, protest, (url) => {}))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Icon(Icons.close));
          },
        );
      },
    );
  }
}
