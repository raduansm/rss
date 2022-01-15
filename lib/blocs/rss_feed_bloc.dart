import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/rss_feed.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class RSSFEEDBloc {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<RSSFEED>> rssFeedUrlsList() async {
    final ref = await firestore.collection('rss_feeds').orderBy('timestamp', descending: false).limit(5).get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(ref.docs);

    return _snap.map((e) => RSSFEED.fromFirestore(e)).toList();
  }

  Future addArticleInFirestore(RssItem item, RSSFEED rssfeed) async {
    print("check started");
    var querySnapshot = await firestore.collection('contents').where('title', isEqualTo: item.title).get();

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    if (querySnapshot.docs.length == 0) {
      Article article = Article(
        title: item.title,
        category: rssfeed.category,
        description: item.description,
        contentType: rssfeed.contentType == "image" || rssfeed.contentType == "video" ? rssfeed.contentType : "image",
        thumbnailImagelUrl: item.enclosure!.url,
        youtubeVideoUrl: null,
        loves: 0,
        sourceUrl: item.link,
        date: DateFormat('dd MMMM yy').format(DateTime.now()),
        timestamp: timestamp,
        views: 0,
      );

      await firestore.collection('contents').doc(timestamp).set(article.toJason());

      await firestore.collection('item_count').doc('contents_count').update({"count": FieldValue.increment(1)});
      print('content uploaded from ${rssfeed.url}');
    }
  }

  Future newArticleUpload() async {
    List<RSSFEED> _rssfeedList = await rssFeedUrlsList();

    for (var rssfeed in _rssfeedList) {
      print('start  ${rssfeed.url}');
      final client = http.Client();
      final response = await client.get(Uri.parse(rssfeed.url.toString()));

      var feed;

      try {
        feed = RssFeed.parse(response.body);
      } catch (_) {
        print("Failed to perse RSSFEED URL");
        continue;
      }

      final numberOfFeedstoFetch = 5;

      for (int i = 0; i < numberOfFeedstoFetch; i++) {
        try {
          await addArticleInFirestore(feed.items![i], rssfeed);
        } catch (_) {
          print("check failed for ${i + 1}");
          continue;
        }
      }
      feed = null;
      print('end ${rssfeed.url}');
    }
  }
}
