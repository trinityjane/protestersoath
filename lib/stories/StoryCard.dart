import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:protestersoath/stories/FeedModel.dart';

Widget StoryCard(BuildContext context, FeedModel story) {
  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL_PROBLEM'.tr()),
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
        story.imageURL.startsWith("assets")
            ? Image.asset(story.imageURL)
            : Image.network(story.imageURL),
        // Title and Summary
        (story.summary == '')
            ? ListTile(
                leading: Icon(Icons.arrow_drop_down_circle),
                title:
                    // Text(story.title),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(story.title, style: TextStyle(fontSize: 20)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child:
                            Text(story.date, style: TextStyle(fontSize: 10))),
                  ],
                ),
                isThreeLine: false,
              )
            : ListTile(
                leading: Icon(Icons.arrow_drop_down_circle),
                title:
                    // Text(story.title),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(story.title, style: TextStyle(fontSize: 20)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child:
                            Text(story.date, style: TextStyle(fontSize: 10))),
                  ],
                ),
                subtitle: Text(
                  story.summary,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.8)),
                ),
                isThreeLine: true,
              ),
        // Date of the story

        // The story
        (story.body != '')
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 10, top: 0, bottom: 5),
                child: story.isHTML
                    ? Html(data: story.body)
                    : Text(
                        story.body,
                        style: TextStyle(
                            fontSize: 15, color: Colors.black.withOpacity(0.8)),
                      ),
              )
            : Container(),

        // Credits

        // link to the story.
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3, right: 10),
              child: GestureDetector(
                child: Text(story.referenceURL, style: TextStyle(fontSize: 10, color: Colors.blue, decoration: TextDecoration.underline)),
                onTap: () => _launchURL(story.referenceURL),
              ),
            )),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 20, right: 10),
            child: Text(
              'Photo: ' + story.credit,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    ),
  );
}
