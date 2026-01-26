import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:protestersoath/feeds/FeedModel.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Widget StoryRSSCard(BuildContext context, FeedModel story, openFeed) {
  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.urlProblem),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showErrorSnackBar();
    }
  }

  // Use CORS proxy for web
  String getImageUrl(String imageUrl) {
    if (kIsWeb && !imageUrl.startsWith('assets')) {
      return 'https://corsproxy.io/?${Uri.encodeComponent(imageUrl)}';
    }
    return imageUrl;
  }

  return Card(
    clipBehavior: Clip.antiAlias,
    color: Colors.grey[400],
    child: Column(
      children: [
        story.imageURL.startsWith("assets")
            ? Image.asset(story.imageURL)
            : CachedNetworkImage(
                imageUrl: getImageUrl(story.imageURL),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/img/protester.png',
                    fit: BoxFit.cover,
                  );
                },
                httpHeaders: {
                  'User-Agent': 'Mozilla/5.0 (compatible; ProtestersOath/1.0)',
                  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                },
              ),
        // Title and Summary
        ListTile(
          leading: Icon(Icons.arrow_drop_down_circle),
          title: Text(story.title, style: TextStyle(fontSize: 20)),
          subtitle: Html(data: story.summary),
          isThreeLine: false,
          onTap: () => openFeed(story.postURL),
        ),

        // The story
        (story.body != '')
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: story.isHTML
                    ? Html(data: story.body)
                    : Text(
                        story.body,
                        style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromRGBO(0, 0, 0, 0.8)),
                      ),
              )
            : Container(),

        // Date and Photo Credit at the bottom right
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16, bottom: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date: ' + story.date,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  'Photo: ' + story.credit,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        // More Information link at the bottom left
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 12, top: 8),
            child: GestureDetector(
              onTap: () => _launchURL(story.referenceURL),
              child: Text(
                'More Information',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
