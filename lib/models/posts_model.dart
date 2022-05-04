import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  String postId;
  String post;
  String likes;
  String ownerName;
  String ownerId;
  String date;

  PostsModel({
    required this.postId,
    required this.post,
    required this.likes,
    required this.ownerName,
    required this.date,
    required this.ownerId,
  });

  factory PostsModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return PostsModel(
      postId: doc.id,
      post: doc.data()!['post'],
      likes: doc.data()!['likes'],
      ownerId: doc.data()!['owner_id'],
      ownerName: doc.data()!['owner_name'],
      date: doc.data()!['date'],
    );
  }
}
