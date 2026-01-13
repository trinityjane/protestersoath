import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/stories/stories_cubit.dart';
import 'package:protestersoath/stories/stories_state.dart';
import 'package:protestersoath/settings/SettingsContainer.dart';

import 'StoryCard.dart';

class StoryPage extends StatefulWidget {
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  void initState() {
    super.initState();
    // Load the first story with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoriesCubit>().getNextStory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer = menuConfig == 'allScreens';
        final bool showBack = (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');

        return BlocBuilder<StoriesCubit, StoriesState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ErrorState) {
              return Center(
                child: Icon(Icons.close),
              );
            } else if (state is LoadedState) {
              return Scaffold(
                drawer: showDrawer ? AppDrawer() : null,
                body: Container(
                  color: Colors.grey,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        title: Text(
                          AppLocalizations.of(context)!.stories,
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.art_track, size: 40),
                            onPressed: () =>
                                context.read<StoriesCubit>().getNextStory(context),
                          ),
                        ],
                        leading: showBack
                            ? IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  BlocProvider.of<AppDrawerBloc>(context)
                                      .add(HomePageEvent());
                                },
                              )
                            : null,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            StoryCard(context, state.story),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Icon(Icons.close),
            );
          },
        );
      },
    );
  }
}
