import 'package:flutter/material.dart';
import 'package:protestersoath/stories/FeedModel.dart';

Widget ProtestRSSCard(BuildContext context, FeedModel protest, Function(String) openFeed) {
  return Card(
    clipBehavior: Clip.antiAlias,
    color: Colors.grey[400],
    child: ListTile(
      leading: Icon(Icons.campaign),
      title: Text(protest.title, style: TextStyle(fontSize: 20)),
      subtitle: Text(protest.summary),
      onTap: () => openFeed(protest.postURL),
    ),
  );
}
