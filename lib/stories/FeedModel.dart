import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:webfeed_revised/webfeed_revised.dart';

class FeedModel {
  String type = 'Story';
  String date = '';
  String title = '';
  String summary = '';
  String body = '';
  String credit = '';
  String imageURL = '';
  String referenceURL = '';
  String postURL = '';
  bool isHTML = false;
  String start = '';
  DateTime end = DateTime.now();
  bool isActive = false;

  FeedModel({
    this.date = '',
    this.title = '',
    this.summary = '',
    this.body = '',
    this.credit = '',
    this.imageURL = '',
    this.referenceURL = '',
    this.postURL = '',
    this.isHTML = false,
    this.start = '',
    DateTime? end,
    this.isActive = false,
  }) : end = end ?? DateTime.now();

  FeedModel.fromRSSFeed(RssItem item) {
    try {
      // Parse the description as HTML to extract structured data
      final document = parse(item.description ?? '');

      String caption = '';
      if (document.getElementsByTagName("figcaption").isNotEmpty) {
        caption = document.getElementsByTagName("figcaption").elementAt(0).text;
      }

      // get information out of the metadata.
      String date = '', credit = '', url = '', start = '', end = '';
      if (document.getElementsByTagName("meta").isNotEmpty) {
        List<Element> meta = document.getElementsByTagName("meta");
        date = meta.elementAt(0).attributes['date'] ?? '';
        credit = meta.elementAt(0).attributes['credit'] ?? '';
        url = meta.elementAt(0).attributes['url'] ?? '';
        start = meta.elementAt(0).attributes['start'] ?? '';
        end = meta.elementAt(0).attributes['end'] ?? '';
      }

      String body = '';
      if (document.getElementsByTagName("p").isNotEmpty) {
        List<Element> bodyHtml = document.getElementsByTagName("p");
        Iterable<String> bodyMap = bodyHtml.map((element) => element.outerHtml);
        body = bodyMap.join('');
      }

      // If no body found in structured format, use the entire description
      if (body.isEmpty) {
        body = item.description ?? '';
      }

      this.date = date.isNotEmpty ? date : (item.pubDate?.toString() ?? '');
      this.title = item.title ?? '';
      this.summary = caption.isNotEmpty ? caption : (item.description ?? '');
      this.body = body;
      this.credit = credit;

      // Try to get image from enclosure or parse from description HTML
      String? imgUrl;
      if (item.enclosure?.url != null &&
          (item.enclosure!.type?.startsWith('image/') ?? false)) {
        imgUrl = item.enclosure!.url;
      } else if (document.getElementsByTagName("img").isNotEmpty) {
        imgUrl = document.getElementsByTagName("img").elementAt(0).attributes['src'];
      }
      this.imageURL = imgUrl ?? 'assets/img/protester.png';

      this.referenceURL = url.isNotEmpty ? url : (item.link ?? '');
      this.postURL = item.link ?? '';
      this.isHTML = body.contains('<');
      this.start = start;

      if (end.isNotEmpty) {
        try {
          this.end = DateTime.parse(end);
          this.isActive = DateTime.now().isBefore(this.end);
        } catch (e) {
          this.end = DateTime.now().add(Duration(days: 30));
          this.isActive = true;
        }
      } else {
        this.end = DateTime.now().add(Duration(days: 30));
        this.isActive = true;
      }

      // Determine type based on metadata or default to Story
      this.type = start.isNotEmpty ? 'Protest' : 'Story';
    } catch (e) {
      print('Error parsing RSS feed item: $e');
      // Set defaults on error
      this.title = item.title ?? 'No Title';
      this.summary = item.description ?? '';
      this.body = item.description ?? '';
      this.imageURL = 'assets/img/protester.png';
      this.postURL = item.link ?? '';
      this.referenceURL = item.link ?? '';
      this.isHTML = false;
      this.type = 'Story';
      this.isActive = true;
      this.date = item.pubDate?.toString() ?? '';
    }
  }
}
