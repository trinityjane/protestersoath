import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/stories/FeedModel.dart';
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

        // link to the story.
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 8, left: 16, bottom: 8),
            child: GestureDetector(
              onTap: () => _launchURL(story.referenceURL),
              child: Text(
                'More Information',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
            child: Text(
              'Photo: ' + story.credit,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 20, right: 10),
            child: Text(
              'Date: ' + story.date,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    ),
  );
}
