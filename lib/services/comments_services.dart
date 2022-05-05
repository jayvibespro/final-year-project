import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  String comment;
  String id;
  String likes;
  String ownerName;
  String ownerId;
  String date;

  CommentService({
    required this.comment,
    required this.id,
    required this.likes,
    required this.ownerName,
    required this.ownerId,
    required this.date,
  });

  addComment() async {
    var addNewComment =
        await FirebaseFirestore.instance.collection('posts').add({
      'post': comment,
      'likes': likes,
      'owner_id': ownerId,
      'owner_name': ownerName,
      'date': date,
    });
  }
}
