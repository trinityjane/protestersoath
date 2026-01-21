import 'package:flutter/material.dart';
import 'package:protestersoath/stories/FeedModel.dart';

Widget ProtestCompactListItem(BuildContext context, FeedModel protest, Function(String) openFeed) {
  return ListTile(
    leading: Icon(Icons.campaign),
    title: Text(protest.title, style: TextStyle(fontSize: 18)),
    subtitle: Text(protest.date),
    onTap: () => openFeed(protest.postURL),
  );
}
