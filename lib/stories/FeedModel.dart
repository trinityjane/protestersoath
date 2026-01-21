import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
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
  String time = '';
  DateTime end = DateTime.now();
  bool isActive = false;
  String location = '';
  String locationUrl = '';

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
    this.time = '',
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
      // Use start for date only
      this._parsedStartDate = this.start;
      // Parse time from HTML content
      this.time = '';
      // Try to find <li>Time<ul><li>...</li></ul></li> structure
      final ulTags = document.getElementsByTagName('ul');
      for (final ul in ulTags) {
        final liTags = ul.getElementsByTagName('li');
        for (final li in liTags) {
          if (li.text.trim().toLowerCase() == 'time') {
            // Look for nested <ul> inside this <li>
            final nestedUls = li.getElementsByTagName('ul');
            if (nestedUls.isNotEmpty) {
              final nestedLis = nestedUls.first.getElementsByTagName('li');
              if (nestedLis.isNotEmpty) {
                this.time = nestedLis.first.text.trim();
                break;
              }
            } else {
              // Also check for a direct child <ul> (not just nested)
              final directUl = li.querySelector('ul');
              if (directUl != null) {
                final directLis = directUl.getElementsByTagName('li');
                if (directLis.isNotEmpty) {
                  this.time = directLis.first.text.trim();
                  break;
                }
              }
            }
          }
        }
        if (this.time.isNotEmpty) break;
      }
      // Fallback: scan all <li> for a time-like string if the above fails
      if (this.time.isEmpty) {
        final allLis = document.getElementsByTagName('li');
        final timeRegExp = RegExp(r'\b\d{1,2}(:\d{2})?\s*[APMapm]{2}\b');
        for (final li in allLis) {
          final match = timeRegExp.firstMatch(li.text);
          if (match != null) {
            this.time = match.group(0)!;
            break;
          }
        }
      }
      // Fallback: try to find time in figcaption (e.g., 4:30 PM)
      if (this.time.isEmpty) {
        final figcaptions = document.getElementsByTagName('figcaption');
        if (figcaptions.isNotEmpty) {
          final timeRegExp = RegExp(r'(\d{1,2}(:\d{2})?\s*[APMapm]{2})');
          final match = timeRegExp.firstMatch(figcaptions.first.text);
          if (match != null) {
            this.time = match.group(1)!;
          }
        }
      }

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

      // Use the first <img> in the HTML for the image
      final imgTags = document.getElementsByTagName('img');
      if (imgTags.isNotEmpty) {
        final src = imgTags.first.attributes['src'];
        if (src != null && src.isNotEmpty) {
          this.imageURL = Uri.encodeFull(src.trim());
        }
      } else {
        // Fallback to enclosure/media/default
        this.imageURL = _extractImageUrl(item, document);
      }
      print('[DEBUG] Parsed imageURL: ' + this.imageURL);

      // Determine type based on start date (Protest vs Story)
      this.type = this.start.isNotEmpty ? 'Protest' : 'Story';

      // Override date if custom date is provided
      if (metadata['date']?.isNotEmpty ?? false) {
        this.date = metadata['date']!;
      }

      // Extract location from <li>Location<ul><li>...</li></ul></li> structure (robust, safe for LinkedMap)
      this.location = '';
      this.locationUrl = '';
      for (final ul in ulTags) {
        final liTags = ul.getElementsByTagName('li');
        for (final li in liTags) {
          // Look for a text node child with 'Location'
          bool isLocationLi = false;
          for (final node in li.nodes) {
            if (node.nodeType == 3) {
              // TEXT_NODE
              final text = node.text?.trim().toLowerCase() ?? '';
              if (text == 'location') {
                isLocationLi = true;
                break;
              }
            }
          }
          if (isLocationLi) {
            // Find the first nested <ul> and get its first <li>
            final nestedUls = li.getElementsByTagName('ul');
            if (nestedUls.isNotEmpty) {
              final nestedLis = nestedUls.first.getElementsByTagName('li');
              if (nestedLis.isNotEmpty) {
                final locationLi = nestedLis.first;
                final anchors = locationLi.getElementsByTagName('a');
                if (anchors.isNotEmpty &&
                    anchors.first.attributes['href'] != null) {
                  this.locationUrl = anchors.first.attributes['href']!.trim();
                  this.location = anchors.first.text.trim();
                } else {
                  this.location = locationLi.text.trim();
                }
                break;
              }
            }
          }
        }
        if (this.location.isNotEmpty) break;
      }
      // Fallback: scan all <a> for a Google Maps or similar location link
      if (this.location.isEmpty || this.locationUrl.isEmpty) {
        final allAnchors = document.getElementsByTagName('a');
        for (final a in allAnchors) {
          final href = a.attributes['href'] ?? '';
          if (href.contains('google.com/maps/search') ||
              href.contains('maps.google.com')) {
            this.locationUrl = href.trim();
            this.location = a.text.trim();
            break;
          }
        }
      }
      // Fallback: extract location from figcaption (look for 📍...)
      if (this.location.isEmpty && figcaptions.isNotEmpty) {
        final figText = figcaptions.first.text;
        final locRegExp = RegExp(r'📍([^📝🔗👥]*)');
        final locMatch = locRegExp.firstMatch(figText);
        if (locMatch != null) {
          this.location = locMatch.group(1)?.trim() ?? '';
        }
      }
    } catch (e) {
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
      // Try RSS format: "Wednesday, April 15, 2026"
      final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
      return dateFormat.parse(endDateStr);
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

  // Store the parsed date part for isUpcoming
  String _parsedStartDate = '';

  bool get isUpcoming {
    if (_parsedStartDate.isEmpty) return false;
    try {
      // Example: "Saturday, February 14, 2026"
      final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
      final startDate = dateFormat.parse(_parsedStartDate);
      return !startDate.isBefore(DateTime.now());
    } catch (e) {
      print('Error parsing start date "$_parsedStartDate": $e');
      return false;
    }
  }
}
