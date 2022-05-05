import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String commentId;
  String comment;
  String ownerName;
  String ownerId;
  String date;

  CommentsModel({
    required this.commentId,
    required this.comment,
    required this.ownerName,
    required this.date,
    required this.ownerId,
  });

  factory CommentsModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return CommentsModel(
      commentId: doc.id,
      comment: doc.data()!['comment'],
      ownerId: doc.data()!['owner_id'],
      ownerName: doc.data()!['owner_name'],
      date: doc.data()!['date'],
    );
  }
}
