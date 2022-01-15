import 'package:cloud_firestore/cloud_firestore.dart';

class RSSFEED {
  String? name;
  String? timestamp;
  String? url;
  String? category;
  String? contentType;

  RSSFEED({
    this.name,
    this.timestamp,
    this.url,
    this.category,
    this.contentType,
  });

  factory RSSFEED.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return RSSFEED(
      name: d['name'],
      timestamp: d['timestamp'],
      url: d['url'],
      category: d['category'],
      contentType: d['contentType'],
    );
  }
}
