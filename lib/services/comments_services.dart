import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  int? commentCount;
  String? comment;
  String? postId;
  String? id;
  String? ownerName;
  String? ownerId;
  String? date;

  CommentService({
    this.commentCount,
    this.comment,
    this.postId,
    this.id,
    this.ownerName,
    this.ownerId,
    this.date,
  });

  addComment() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    var addNewComment = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': comment,
      'owner_id': _auth.currentUser?.uid,
      'owner_name': _auth.currentUser?.email,
      'date': date,
    });

    var commentAdder = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({
      'comment_count': commentCount,
    });
  }
}
