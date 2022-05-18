import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  String? post;
  String? id;
  int? likes;
  int? commentCount;
  String? ownerName;
  String? ownerId;
  String? date;

  PostService({
    this.commentCount,
    this.id,
    this.post,
    this.likes,
    this.ownerName,
    this.ownerId,
    this.date,
  });

  addPost() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      var addNewPost =
          await FirebaseFirestore.instance.collection('posts').add({
        'post': post,
        'likes': likes,
        'comment_count': commentCount,
        'owner_id': _auth.currentUser?.uid,
        'owner_name': _auth.currentUser?.email,
        'date': date,
      });
    } catch (e) {
      print('Failed to create a post.');
      print(e);
    }
  }

  updateLike() async {
    try {
      var like =
          await FirebaseFirestore.instance.collection('posts').doc(id).update({
        'likes': likes,
      });
    } catch (e) {
      print('An error occurred.');
      print(e);
    }
  }
}
