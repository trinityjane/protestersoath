import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class StoryModel {
  final String type = 'Story';
  String date;
  String title;
  String summary;
  String body;
  String credit;
  String imageURL;
  String referenceURL;
  String postURL;
  bool isHTML;

  StoryModel({
    this.date = '',
    this.title = '',
    this.summary = '',
    this.body = '',
    this.credit = '',
    this.imageURL = '',
    this.referenceURL = '',
    this.postURL = '',
    this.isHTML = false,
  });

  StoryModel.fromMap(Map<String, dynamic> item)
      : date = '',
        title = '',
        summary = '',
        body = '',
        credit = '',
        imageURL = 'assets/img/protester.png',
        referenceURL = '',
        postURL = '',
        isHTML = false {
    try {
      // Defensive: handle both String and Map for 'content'
      final dynamic content = item['content'];
      String contentString = '';
      List<dynamic> images = [];
      if (content is String) {
        contentString = content.trim();
      } else if (content is Map<String, dynamic>) {
        contentString = (content['html'] ?? '').toString().trim();
        images = content['images'] is List ? content['images'] : [];
      }
      final document = parse(contentString);

      String caption = document.getElementsByTagName("figcaption").isNotEmpty
          ? document.getElementsByTagName("figcaption").elementAt(0).innerHtml
          : '';

      String date = '', credit = '', url = '';
      if (document.getElementsByTagName("meta").isNotEmpty) {
        List<Element> meta = document.getElementsByTagName("meta");
        for (final m in meta) {
          if (m.attributes.containsKey('date')) {
            date = m.attributes['date'] ?? '';
          }
          if (m.attributes.containsKey('credit')) {
            credit = m.attributes['credit'] ?? '';
          }
          if (m.attributes.containsKey('url')) {
            url = m.attributes['url'] ?? '';
          }
        }
      }
      String body = '';
      if (document.getElementsByTagName("p").isNotEmpty) {
        List<Element> bodyHtml = document.getElementsByTagName("p");
        Iterable<String> bodyMap = bodyHtml.map((element) => element.innerHtml);
        body = bodyMap.join('<p>') != ''
            ? '<p>' + bodyMap.join('</p><p>') + '</p>'
            : '';
      }

      this.date = date;
      this.title = item['title'] ?? '';
      this.summary = caption;
      this.body = body;
      this.credit = credit;
      // Defensive: handle images from both content map and fallback
      if (images.isNotEmpty && images[0] is String && images[0].isNotEmpty) {
        this.imageURL = images[0];
      } else if (content is Map<String, dynamic> &&
          content['images'] is List &&
          content['images'].isNotEmpty) {
        this.imageURL = content['images'][0];
      } else {
        this.imageURL = 'assets/img/protester.png';
      }
      this.referenceURL = url;
      this.postURL = item['link'] ?? '';
      this.isHTML = true;
    } catch (e) {
      // Fallback to safe defaults on error
      this.date = '';
      this.title = '';
      this.summary = '';
      this.body = '';
      this.credit = '';
      this.imageURL = 'assets/img/protester.png';
      this.referenceURL = '';
      this.postURL = '';
      this.isHTML = false;
      print('FeedModel.fromMap error: \\${e.toString()}');
    }
  }
}
/*

<figure class="wp-block-image size-large is-resized">
<img loading="lazy" src="https://protestersoath.com/wp-content/uploads/2020/10/story000-1024x556.jpg"
alt="" class="wp-image-26" width="610" height="331"
srcset="https://protestersoath.com/wp-content/uploads/2020/10/story000-1024x556.jpg 1024w,
https://protestersoath.com/wp-content/uploads/2020/10/story000-300x163.jpg 300w,
https://protestersoath.com/wp-content/uploads/2020/10/story000-768x417.jpg 768w,
https://protestersoath.com/wp-content/uploads/2020/10/story000-1200x652.jpg 1200w,
https://protestersoath.com/wp-content/uploads/2020/10/story000.jpg 1414w"
sizes="(max-width: 610px) 100vw, 610px" />
<figcaption>A menorah is displayed in a window in defiance of Nazi politics. <br>(Photo 12/Universal Images Group via Getty Images)</figcaption>
</figure>

<p>One month before Hitler rose to power, a Jewish family living in Germany defiantly displayed a Hanukkah menorah in their window across from a Nazi flag.</p>

<meta name="date" content="1932">
<meta credit="Photo 12/Universal Images Group via Getty Images">
<meta url="https://en.wikipedia.org/wiki/The_Holocaust">

 */
