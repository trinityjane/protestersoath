import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

class RSSReader extends StatefulWidget {
  RSSReader({this.which = 'Stories', this.title = ''}) : super();

  final which;

  // Setting title for the action bar.
  final String title;

  @override
  RSSReaderState createState() => RSSReaderState();
}

class RSSReaderState extends State<RSSReader> {
  List<FeedModel> _cards = [];
  List<FeedModel> _stories = [];
  List<FeedModel> _protests = [];
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  String _title = ''; // Place holder for appbar title.

  // Notification Strings
  static String loadingMessage = 'LOADING_FEED'.tr();
  static String feedLoadErrorMessage = 'FEED_LOAD_ERROR'.tr();
  static String feedOpenErrorMessage = 'FEED_OPEN_ERROR'.tr();

  // Method to change the title as a way to inform the user what is going on
  // while retrieving the RSS data.
  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  // Method to help refresh the RSS data.
  // separate out stories and protest information from other posts.
  updateFeed(feed) async {
    _cards = [for (var item in feed.items) FeedModel.fromRSSFeed(item)];
    setState(() {
      _stories = _cards.where((card) => card.type == 'Story').toList();
    });
    setState(() {
      _protests = _cards.where((card) => card.type == 'Protest').toList();
    });
  }

  // Method to navigate to the URL of a RSS feed item.
  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMessage);
  }

  // Method to load the RSS data.
  load() async {
    updateTitle(loadingMessage);
    RSSReader.haveFeed = RSSReader.lastFeed.difference(DateTime.now());
    if (RSSReader.haveFeed.inHours > 4 ||
        RSSReader.feed == null ||
        RSSReader.feed.items.length == 0) {
      loadFeed().then((result) {
        if (null == result || result.toString().isEmpty) {
          // Notify user of error.
          updateTitle(feedLoadErrorMessage);
          return;
        }
        // If there is no error, load the RSS data into the _feed object.
        updateFeed(result);
        // cache the result in a static object in memory.
        RSSReader.feed = result;
        updateTitle(widget.title);
      });
    } else {
      updateFeed(RSSReader.feed);
      updateTitle(widget.title);
    }
    // Reset the title.
  }

  // Method to get the RSS data from the provided URL in the FEED_URL variable.
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(RSSReader.FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      // handle any exceptions here
      // PrefService.setString('stories', 'pages');
      // BlocProvider.of<AppDrawerBloc>(context)
      //     .add(BackButtonEvent("StoryPage"));
      // print("Error: " + e);
      return null;
    }
  }

  // When the app is initialized, we setup our GlobalKey, set our title, and
  // call the load() method which loads the RSS feed and UI.
  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  // Method to check if the RSS feed is empty.
  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  // Method for the pull to refresh indicator and the actual ListView UI/Data.
  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: this.drawer == 'all' ? AppDrawer() : null,
        backgroundColor: Colors.grey, // colorHackerBackground,
        appBar: AppBar(
          // pinned: true,
          // expandedHeight: appBarHeight,
          title: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),

          leading: drawer == 'all'
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

  // ==================== ListView Components ====================
  list() {
    var listToShow = widget.which == 'Stories' ? _stories : _protests;
    return Stack(children: <Widget>[
      Container(
          color: Colors.grey,
          child: CustomScrollView(slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (widget.which == 'Stories') {
                    final item = listToShow[index];
                    FeedModel story = item;
                    return Container(
                        margin: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        decoration: customBoxDecoration(),
                        child: StoryRSSCard(context, story, openFeed));
                  } else {
                    final item = listToShow[index];
                    FeedModel protest = item;
                    return protest.isActive
                        ? Container(
                            margin: EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            decoration: customBoxDecoration(),
                            child: ProtestRSSCard(context, protest, openFeed),
                          )
                        : Container();
                  }
                },
                childCount: listToShow.length,
              ),
            ),
          ])),
      listToShow.length > 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "NOTHINGTOSHOW".tr(),
                style: TextStyle(
                    fontSize: 25, color: Colors.black.withOpacity(0.8)),
              )),
    ]);
  }

  // Method that returns the Text Widget for the title of our RSS data.
  title(title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Method that returns the Text Widget for the subtitle of our RSS data.
  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(
          fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Method that returns Icon Widget.
  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.white,
      size: 30.0,
    );
  }

  // Custom box decoration for the Container Widgets.
  BoxDecoration customBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.white, // border color
        width: 1.0,
      ),
    );
  }

// ====================  End ListView Components ====================
}
