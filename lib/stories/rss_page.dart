import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:protestersoath/navigation/app_drawer.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/protests/ProtestCompactListItem.dart';
import 'package:protestersoath/protests/ProtestRSSCard.dart';
import 'package:protestersoath/settings/SettingsContainer.dart';
import 'package:protestersoath/stories/FeedModel.dart';
import 'package:protestersoath/stories/StoryRSSCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed_revised/webfeed_revised.dart';

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
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  String _title = '';
  bool _isLoading = false;
  String? _errorMessage;

  static final Map<String, RssFeed> _feedCache = {};

  // static const String STORIES_RSS_URL = 'https://protestersoath.com/?feed=rss2';
  // static const String PROTESTS_RSS_URL =
  //     'https://protestersoath.com/?feed=rss2';

  static const String STORIES_RSS_URL =
      'https://protestersoath.com/category/stories/feed/';
  static const String PROTESTS_RSS_URL =
      'https://protestersoath.com/category/protests/feed/';

  String get loadingMessage => 'Loading feed...';

  String get feedLoadErrorMessage => 'Error loading feed. Pull down to retry.';

  String get feedOpenErrorMessage => 'Feed open error.';

  void updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void updateFeed(RssFeed feed) {
    setState(() {
      _cards =
          feed.items?.map((item) => FeedModel.fromRSSFeed(item)).toList() ?? [];
      _stories = _cards.where((card) => card.type == 'Story').toList();
      _protests = _cards.where((card) => card.type == 'Protest').toList();
      _isLoading = false;
      _errorMessage = null;
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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    updateTitle(loadingMessage);

    try {
      String feedUrl =
          widget.which == 'Stories' ? STORIES_RSS_URL : PROTESTS_RSS_URL;

      // For web, use a CORS proxy
      if (kIsWeb) {
        feedUrl = 'https://corsproxy.io/?${Uri.encodeComponent(feedUrl)}';
      }

      // Check if caching is disabled (dev mode only)
      bool disableCache = false;
      if (kDebugMode) {
        disableCache = await SettingsContainer.getDisableRssFeedCache();
        print('[DEBUG] Disable RSS Feed Cache: $disableCache');
      }

      // Add cache-busting param if caching is disabled
      if (disableCache) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (feedUrl.contains('?')) {
          feedUrl += '&cb=$now';
        } else {
          feedUrl += '?cb=$now';
        }
        print('[DEBUG] Cache-busting param added: $feedUrl');
      }

      RssFeed? feed;
      if (!disableCache && _feedCache.containsKey(feedUrl)) {
        print('[DEBUG] Loading feed from cache for $feedUrl');
        feed = _feedCache[feedUrl];
      } else {
        print('[DEBUG] Fetching feed from network for $feedUrl');
        final response = await http.get(
          Uri.parse(feedUrl),
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; ProtestersOath/1.0)',
            'Accept': 'application/rss+xml, application/xml, text/xml, */*',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'Expires': '0',
          },
        ).timeout(
          Duration(seconds: 30),
        );
        print('[DEBUG] Network response status: \\${response.statusCode}');
        print(
            '[DEBUG] Raw response body (first 500 chars): \\${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');
        if (response.statusCode == 200) {
          feed = RssFeed.parse(response.body);
          print('[DEBUG] Parsed feed items: \\${feed.items?.length ?? 0}');
          if (!disableCache) {
            _feedCache[feedUrl] = feed;
            print('[DEBUG] Feed cached for $feedUrl');
          }
        } else {
          print(
              '[DEBUG] Network error: \\${response.statusCode} \\${response.reasonPhrase}');
          throw Exception(
              'HTTP \\${response.statusCode}: \\${response.reasonPhrase}');
        }
      }
      if (feed != null) {
        updateFeed(feed);
        updateTitle(widget.title);
      }
    } catch (e, stackTrace) {
      print('Error loading RSS feed: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load feed: $e';
      });
      updateTitle(feedLoadErrorMessage);
    }
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
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(loadingMessage, style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (_errorMessage != null && isFeedEmpty()) {
      return RefreshIndicator(
        key: _refreshKey,
        onRefresh: load,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    feedLoadErrorMessage,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _errorMessage ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pull down to retry',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      key: _refreshKey,
      child: list(),
      onRefresh: load,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SettingsContainer.getMenuConfig(),
      builder: (context, snapshot) {
        final menuConfig = snapshot.data ?? 'homeOnly';
        final bool showDrawer = menuConfig == 'allScreens';
        final bool showBack =
            (menuConfig == 'homeOnly' || menuConfig == 'buttonsOnly');

        return SafeArea(
          child: Scaffold(
            drawer: showDrawer ? AppDrawer() : null,
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                _title,
                style: TextStyle(color: Colors.white),
              ),
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
            body: body(),
          ),
        );
      },
    );
  }

  Widget list() {
    var listToShow = widget.which == 'Stories' ? _stories : _protests;

    if (listToShow.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nothing to show',
                    style: TextStyle(
                        fontSize: 25,
                        color: const Color.fromRGBO(0, 0, 0, 0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Use a FutureBuilder to get the compact mode setting
    return FutureBuilder<bool>(
      future: SettingsContainer.getProtestsCompactMode(),
      builder: (context, snapshot) {
        final bool compactMode = snapshot.data ?? false;
        return Container(
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
                    if (!protest.isUpcoming) return Container();
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: customBoxDecoration(),
                      child: compactMode
                          ? ProtestCompactListItem(context, protest, openFeed)
                          : ProtestRSSCard(context, protest, openFeed),
                    );
                  }
                },
                childCount: listToShow.length,
              ),
            ),
          ]),
        );
      },
    );
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
