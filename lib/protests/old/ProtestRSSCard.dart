import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/stories/FeedModel.dart';
import 'package:url_launcher/url_launcher.dart';

Widget ProtestRSSCard(BuildContext context, FeedModel protest, openFeed) {
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
        protest.imageURL.startsWith("assets")
            ? Image.asset(protest.imageURL)
            : CachedNetworkImage(
                imageUrl: getImageUrl(protest.imageURL),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) {
                  print('Image load error for $url: $error');
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
        // ...existing code...
        ListTile(
          leading: Icon(Icons.arrow_drop_down_circle),
          title: Text(protest.title, style: TextStyle(fontSize: 22)),
          // make this the date of the protest:
          subtitle: Text(protest.start, style: TextStyle(fontSize: 18)),
          isThreeLine: false,
          onTap: () => openFeed(protest.postURL),
        ),
        // The story
        (protest.postURL != '')
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: protest.isHTML
                    ? Html(data: protest.postURL)
                    : Text(protest.postURL,
                        style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromRGBO(0, 0, 0, 0.8))),
              )
            : Container(),
        // Credits
        // link to the story.
        // Align(
        //     alignment: Alignment.centerRight,
        //     child: Padding(
        //       padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
        //       child: GestureDetector(
        //         child: Text(protest.referenceURL,
        //             style: TextStyle(
        //                 decoration: TextDecoration.underline,
        //                 fontSize: 20,
        //                 color: Colors.blue)),
        //         onTap: () => _launchURL(protest.referenceURL),
        //       ),
        //     )),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
        //     child: Text(
        //       'Photo Credit: ' + protest.credit,
        //       style: TextStyle(fontSize: 10),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 3, bottom: 20, right: 10),
        //     child: Text(
        //       'Date: ' + protest.date,
        //       style: TextStyle(fontSize: 10),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
