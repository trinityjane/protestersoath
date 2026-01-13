import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:protestersoath/stories/FeedModel.dart';
import 'package:protestersoath/stories/StoryRSSCard.dart';
import 'package:protestersoath/stories/ProtestRSSCard.dart';

// TODO: Import RSS parsing dependencies as needed

class RSSReader extends StatefulWidget {
  RSSReader({this.which = 'Stories', this.title = ''});
  final String which;
  final String title;
  @override
  RSSReaderState createState() => RSSReaderState();
}

class RSSReaderState extends State<RSSReader> {
  List<FeedModel> _cards = <FeedModel>[];
  List<FeedModel> _stories = <FeedModel>[];
  List<FeedModel> _protests = <FeedModel>[];
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  String _title = '';

  // Notification Strings (now using AppLocalizations)
  String get loadingMessage => 'Loading feed...';
  String get feedLoadErrorMessage => 'Feed load error.';
  String get feedOpenErrorMessage => 'Feed open error.';

  void updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void updateFeed(feed) async {
    // TODO: Replace with actual FeedModel parsing
    _cards = [for (var item in feed.items) FeedModel.fromRSSFeed(item)];
    setState(() {
      _stories = _cards.where((card) => card != null && card.type == 'Story').toList();
      _protests = _cards.where((card) => card != null && card.type == 'Protest').toList();
    });
  }

  Future<void> openFeed(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    updateTitle(feedOpenErrorMessage);
  }

  Future<void> load() async {
    updateTitle(loadingMessage);
    // TODO: Implement RSS caching and fetching logic
    // For now, just simulate a load error
    updateTitle(feedLoadErrorMessage);
  }

  @override
  void initState() {
    super.initState();
    updateTitle(widget.title);
    load();
  }

  bool isFeedEmpty() {
    return _stories.isEmpty && _protests.isEmpty;
  }

  Widget body() {
    return isFeedEmpty()
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: load,
          );
  }

  @override
  Widget build(BuildContext context) {
    final bool showDrawer = true; // Always show drawer for now
    return SafeArea(
      child: Scaffold(
        drawer: showDrawer ? AppDrawer() : null,
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),
          leading: showDrawer
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    BlocProvider.of<AppDrawerBloc>(context)
                        .add(BackButtonEvent("StoryPage"));
                  },
                ),
        ),
        body: body(),
      ),
    );
  }

  Widget list() {
    var listToShow = widget.which == 'Stories' ? _stories : _protests;
    return Stack(children: <Widget>[
      Container(
        color: Colors.grey,
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (widget.which == 'Stories') {
                  final FeedModel story = listToShow[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: customBoxDecoration(),
                    child: StoryRSSCard(context, story, openFeed),
                  );
                } else {
                  final FeedModel protest = listToShow[index];
                  return protest.isActive
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: customBoxDecoration(),
                          child: ProtestRSSCard(context, protest, openFeed),
                        )
                      : Container();
                }
              },
              childCount: listToShow.length,
            ),
          ),
        ]),
      ),
      listToShow.isNotEmpty
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Nothing to show',
                style: TextStyle(fontSize: 25, color: const Color.fromRGBO(0, 0, 0, 0.8)),
              ),
            ),
    ]);
  }

  BoxDecoration customBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
    );
  }
}
