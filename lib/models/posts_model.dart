import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  String id;
  int commentCount;
  String post;
  int likes;
  String ownerName;
  String ownerId;
  String date;

  PostsModel({
    required this.id,
    required this.commentCount,
    required this.post,
    required this.likes,
    required this.ownerName,
    required this.date,
    required this.ownerId,
  });

  factory PostsModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return PostsModel(
      id: doc.id,
      commentCount: doc.data()!['comment_count'],
      post: doc.data()!['post'],
      likes: doc.data()!['likes'],
      ownerId: doc.data()!['owner_id'],
      ownerName: doc.data()!['owner_name'],
      date: doc.data()!['date'],
    );
  }
}
