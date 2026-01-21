import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/protests/bloc/FeedModel.dart';
import 'package:url_launcher/url_launcher.dart';

Widget ProtestRSSCard(
    BuildContext context, FeedModel protest, Function(String) openFeed) {
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

  String getImageUrl(String imageUrl) {
    if (kIsWeb && !imageUrl.startsWith('assets')) {
      // Only add proxy if not already proxied
      if (!imageUrl.startsWith('https://corsproxy.io/?')) {
        return 'https://corsproxy.io/?' + imageUrl;
      }
    }
    return imageUrl;
  }

  return Card(
    clipBehavior: Clip.antiAlias,
    color: Colors.grey[400],
    child: Column(
      children: [
        protest.imageURL.startsWith("assets")
            ? Image.asset(protest.imageURL)
            : CachedNetworkImage(
                imageUrl: getImageUrl(protest.imageURL),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) {
                  print('Error loading image from $url: $error');
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
        ListTile(
          leading: Icon(Icons.campaign),
          title: Text(
            protest.title,
            style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          // subtitle: Html(data: protest.postURL),
          isThreeLine: false,
          onTap: () => openFeed(protest.postURL),
        ),
        // Description --> Body
        (protest.body != '')
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: protest.isHTML
                    ? Html(data: protest.body)
                    : Text(
                        protest.body,
                        style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromRGBO(0, 0, 0, 0.8)),
                      ),
              )
            : Container(),
        // Date, time, and location of the protest at the bottom
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Date: ' + protest.date,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  protest.time.isNotEmpty
                      ? 'Time ' + protest.time
                      : 'Time Unknown',
                  style: TextStyle(fontSize: 15),
                ),
                if (protest.location.isNotEmpty)
                  protest.locationUrl.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _launchURL(protest.locationUrl),
                          child: Text(
                            protest.location,
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : Text(
                          protest.location,
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
              ],
            ),
          ),
        ),
        // Protest Information --> referenceURL (moved to bottom)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
            child: GestureDetector(
              onTap: () => _launchURL(protest.referenceURL),
              child: Text(
                'Protest Information',
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
      ],
    ),
  );
}
