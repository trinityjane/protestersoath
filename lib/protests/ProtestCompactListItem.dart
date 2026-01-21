import 'package:flutter/material.dart';
import 'package:protestersoath/protests/bloc/FeedModel.dart';
import 'package:url_launcher/url_launcher.dart';

Widget ProtestCompactListItem(
    BuildContext context, FeedModel protest, Function(String) openFeed) {
  return ListTile(
    leading: Icon(Icons.campaign),
    title: Text(protest.title, style: TextStyle(fontSize: 18)),
    subtitle: Builder(
      builder: (context) {
        final subtitleParts = [protest.date];
        if (protest.time.isNotEmpty) subtitleParts.add(protest.time);
        Widget? locationWidget;
        if (protest.location.isNotEmpty) {
          if (protest.locationUrl.isNotEmpty) {
            locationWidget = GestureDetector(
              onTap: () async {
                final uri = Uri.parse(protest.locationUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                protest.location,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          } else {
            locationWidget = Text(protest.location);
          }
        }
        // Compose the subtitle row
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(subtitleParts.join(' • ')),
            ),
            if (locationWidget != null) ...[
              if (subtitleParts.length > 0) Text(' • '),
              locationWidget,
            ],
          ],
        );
      },
    ),
    onTap: () => openFeed(protest.postURL),
  );
}
