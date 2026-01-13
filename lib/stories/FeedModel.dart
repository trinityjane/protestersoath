import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

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

  FeedModel.fromRSSFeed(dynamic item) {
    // Minimal stub for demo/testing
    title = item.title ?? '';
    summary = item.summary ?? '';
    body = item.body ?? '';
    credit = item.credit ?? '';
    imageURL = item.imageURL ?? 'assets/img/protester.png';
    referenceURL = item.referenceURL ?? '';
    postURL = item.postURL ?? '';
    isHTML = item.isHTML ?? false;
    start = item.start ?? '';
    end = item.end ?? DateTime.now();
    isActive = item.isActive ?? true;
    type = item.type ?? 'Story';
    date = item.date ?? '';
  }

  // FeedModel.fromRSSFeed(RssItem item) {
  //   try {
  //     final document = parse(item.content.value.trim());

  //     String caption = document.getElementsByTagName("figcaption").isNotEmpty
  //         ? document.getElementsByTagName("figcaption").elementAt(0).innerHtml
  //         : '';

  //     // get information out of the metadata.
  //     String date = '', credit = '', url = '', start = '', end = '';
  //     if (document.getElementsByTagName("meta").isNotEmpty) {
  //       List<Element> meta = document.getElementsByTagName("meta");
  //       date = meta.elementAt(0).attributes['date'];
  //       credit = meta.elementAt(0).attributes['credit'];
  //       url = meta.elementAt(0).attributes['url'];
  //       start = meta.elementAt(0).attributes['start'];
  //       end = meta.elementAt(0).attributes['end'];
  //     }
  //     String body = '';
  //     if (document.getElementsByTagName("p").isNotEmpty) {
  //       List<Element> bodyHtml = document.getElementsByTagName("p");
  //       Iterable<String> bodyMap = bodyHtml.map((element) => element.innerHtml);
  //       body = bodyMap
  //           .reduce((value, element) => value + '<p>' + element + '</p>');
  //     }

  //     this.date = date.toString();
  //     this.title = item.title;
  //     this.summary = caption;
  //     this.body = body;
  //     this.credit = credit;
  //     this.imageURL = item.content.images.isNotEmpty
  //         ? item.content.images.elementAt(0)
  //         : 'assets/img/protester.png';
  //     this.referenceURL = url;
  //     this.postURL = item.link;
  //     this.isHTML = true;
  //     this.start = start;
  //     this.end = DateTime.parse(end);
  //     this.isActive = DateTime.now().isBefore(this.end);
  //     this.type = 'Protest';
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
