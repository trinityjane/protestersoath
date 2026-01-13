import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/protests/old/protests_cubit.dart';
import 'package:protestersoath/protests/old/protests_state.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

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
                        onPressed: () => context.read<ProtestsCubit>().getNextProtest(),
                      ),
                    ],
                    leading: widget.drawer == 'all'
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              BlocProvider.of<AppDrawerBloc>(context)
                                  .add(const BackButtonEvent("ProtestPage"));
                            },
                          ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // TODO: Add ProtestRSSCard widgets here as needed, e.g.:
                        // ProtestRSSCard(context, state.protest, ...),
                      ],
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
