import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:protestersoath/stories/FeedModel.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

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

  return Card(
    clipBehavior: Clip.antiAlias,
    color: Colors.grey[400],
    child: Column(
      children: [
        protest.imageURL.startsWith("assets")
            ? Image.asset(protest.imageURL)
            : Image.network(protest.imageURL),
        // Title and Summary
        ListTile(
          leading: Icon(Icons.arrow_drop_down_circle),
          title: Text(protest.title, style: TextStyle(fontSize: 22)),
          // make this the date of the protest:
          subtitle: Text(protest.start, style: TextStyle(fontSize: 18)),
          isThreeLine: false,
          onTap: () => openFeed(protest.postURL),
        ),
        // The story
        (protest.body != '')
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: protest.isHTML
                    ? Html(data: protest.body)
                    : Text(protest.body, style: TextStyle(fontSize: 15, color: const Color.fromRGBO(0, 0, 0, 0.8))),
              )
            : Container(),
        // Credits
        // link to the story.
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
              child: GestureDetector(
                child: Text(protest.referenceURL, style: TextStyle(decoration:TextDecoration.underline, fontSize: 20, color: Colors.blue)),
                onTap: () => _launchURL(protest.referenceURL),
              ),
            )),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
            child: Text(
              'Photo Credit: ' + protest.credit,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 20, right: 10),
            child: Text(
              'Date: ' + protest.date,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    ),
  );
}
