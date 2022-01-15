import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/services/app_service.dart';

class Article {
  String? category;
  String? contentType;
  String? title;
  String? description;
  String? thumbnailImagelUrl;
  String? youtubeVideoUrl;
  String? videoID;
  int? loves;
  String? sourceUrl;
  String? date;
  String? timestamp;
  int? views;

  Article({
    this.category,
    this.contentType,
    this.title,
    this.description,
    this.thumbnailImagelUrl,
    this.youtubeVideoUrl,
    this.videoID,
    this.loves,
    this.sourceUrl,
    this.date,
    this.timestamp,
    this.views,
  });

  Map<String, dynamic> toJason() => {
        'category': category,
        'content type': contentType,
        'title': title,
        'description': description,
        'image url': thumbnailImagelUrl,
        'youtube url': youtubeVideoUrl,
        'loves': loves,
        'source': sourceUrl,
        'date': date,
        'timestamp': timestamp,
        'views': views,
      };

  factory Article.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Article(
      category: d['category'],
      contentType: d['content type'],
      title: d['title'],
      description: d['description'],
      thumbnailImagelUrl: d['image url'],
      youtubeVideoUrl: d['youtube url'],
      videoID: d['content type'] == 'video' && d['youtube url'] != null ? AppService.getYoutubeVideoIdFromUrl(d['youtube url']) : '',
      loves: d['loves'],
      sourceUrl: d['source'],
      date: d['date'],
      timestamp: d['timestamp'],
      views: d['views'] ?? null,
    );
  }
}
