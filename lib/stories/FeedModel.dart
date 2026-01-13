import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'dart:math';

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

  String _decodeHtmlEntities(String html) {
    return html
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&#8230;', '...')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");
  }

  FeedModel.fromRSSFeed(RssItem item) {
    try {
      // RSS 2.0 standard fields
      this.title = item.title?.trim() ?? 'No Title';
      this.postURL = item.link?.trim() ?? '';

      // Parse pubDate from RSS 2.0 format
      this.date = _parsePubDate(item.pubDate);

      // Parse description HTML content
      final descriptionHtml = item.content?.value ?? item.description ?? '';
      final decodedHtml = _decodeHtmlEntities(descriptionHtml);
      final document = parse(decodedHtml, generateSpans: true);

      // Extract structured data from custom meta tags
      final metadata = _extractMetadata(document);
      this.credit = metadata['credit'] ?? '';
      this.referenceURL = metadata['url']?.trim() ?? this.postURL;
      this.start = metadata['start'] ?? '';

      // Parse end date and determine if active
      final endDateStr = metadata['end'] ?? '';
      this.end = _parseEndDate(endDateStr);
      this.isActive = DateTime.now().isBefore(this.end);


      // Extract caption from figcaption
      String caption = '';
      final figcaptions = document.getElementsByTagName('figcaption');

      if (figcaptions.isNotEmpty) {
        caption = figcaptions.first.text.trim();
      }

      if (caption.isEmpty) {
        print('Caption is empty, using default');
      }

      // Extract body from paragraph tags
      String body = _extractBody(document);
      if (body.isEmpty) {
        body = descriptionHtml;
      }
      this.body = body;
      this.summary = caption.isNotEmpty ? caption : 'Link for more information';
      this.isHTML = body.contains('<');

      // Extract image URL from RSS 2.0 enclosure or HTML img tag
      this.imageURL = _extractImageUrl(item, document);

      // Determine type based on start date (Protest vs Story)
      this.type = this.start.isNotEmpty ? 'Protest' : 'Story';

      // Override date if custom date is provided
      if (metadata['date']?.isNotEmpty ?? false) {
        this.date = metadata['date']!;
      }} catch (e) {
      print('Error parsing RSS 2.0 feed item: $e');
      _setDefaults(item);
    }
  }

  String _parsePubDate(DateTime? pubDate) {
    if (pubDate == null) return '';
    try {
      // Format as readable date string
      return '${pubDate.year}-${pubDate.month.toString().padLeft(2, '0')}-${pubDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return pubDate.toString();
    }
  }

  Map<String, String> _extractMetadata(Document document) {
    final metadata = <String, String>{};
    final metaTags = document.getElementsByTagName('meta');

    if (metaTags.isNotEmpty) {
      final firstMeta = metaTags.first.attributes;
      metadata['date'] = firstMeta['date'] ?? '';
      metadata['credit'] = firstMeta['credit'] ?? '';
      metadata['url'] = firstMeta['url'] ?? '';
      metadata['start'] = firstMeta['start'] ?? '';
      metadata['end'] = firstMeta['end'] ?? '';
    }

    return metadata;
  }

  String _extractBody(Document document) {
    final paragraphs = document.getElementsByTagName('p');
    if (paragraphs.isEmpty) return '';

    return paragraphs.map((p) => p.outerHtml).join('');
  }

  String _extractImageUrl(RssItem item, Document document) {
    String imageUrl = '';

    // First try RSS 2.0 enclosure (standard for media attachments)
    if (item.enclosure?.url != null) {
      final enclosureType = item.enclosure!.type?.toLowerCase() ?? '';
      if (enclosureType.startsWith('image/')) {
        imageUrl = item.enclosure!.url!;
        return imageUrl;
      }
    }

    // Try media:content (Media RSS extension)
    if (item.media?.contents != null && item.media!.contents!.isNotEmpty) {
      final mediaContent = item.media!.contents!.first;
      if (mediaContent.url != null) {
        imageUrl = mediaContent.url!;
        return imageUrl;
      }
    }

    // Fall back to parsing img tag from description HTML
    final imgTags = document.getElementsByTagName('img');
    if (imgTags.isNotEmpty) {
      final src = imgTags.first.attributes['src'];
      if (src != null && src.isNotEmpty) {
        imageUrl = Uri.encodeFull(src.trim()); // Add this encoding
        return imageUrl;
      }
    }

    // Default fallback image
    print('No image found, using default');
    return 'assets/img/protester.png';
  }

  DateTime _parseEndDate(String endDateStr) {
    if (endDateStr.isEmpty) {
      return DateTime.now().add(Duration(days: 30));
    }

    try {
      return DateTime.parse(endDateStr);
    } catch (e) {
      print('Error parsing end date "$endDateStr": $e');
      return DateTime.now().add(Duration(days: 30));
    }
  }

  void _setDefaults(RssItem item) {
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
    this.end = DateTime.now().add(Duration(days: 30));
  }
}
