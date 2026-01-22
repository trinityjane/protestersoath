import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/app_drawer_event.dart';
import 'package:protestersoath/protests/ProtestRSSCard.dart';
import 'package:protestersoath/protests/bloc/protests_cubit.dart';
import 'package:protestersoath/protests/bloc/protests_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProtestPage extends StatefulWidget {
  const ProtestPage({Key? key, this.drawer}) : super(key: key);
  final String? drawer;

  @override
  _ProtestPageState createState() => _ProtestPageState();
}

class _ProtestPageState extends State<ProtestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProtestsCubit, ProtestsState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorState) {
          return const Center(child: Icon(Icons.close));
        } else if (state is LoadedState) {
          return Scaffold(
            drawer: widget.drawer == 'all' ? const AppDrawer() : null,
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
                    leading: widget.drawer == 'all'
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () async {
                              if (menuConfig != 'buttonsOnly' &&
                                  menuConfig != 'allScreens') {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final menuBackOpensDrawer =
                                    prefs.getBool('menuBackOpensDrawer') ??
                                        false;
                                if (menuBackOpensDrawer) {
                                  await prefs.setBool('openDrawerOnHome', true);
                                }
                              }
                              BlocProvider.of<AppDrawerBloc>(context)
                                  .add(HomePageEvent());
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                          ),
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
  }
}
