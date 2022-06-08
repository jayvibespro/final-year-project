import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PostService {
  String? post;
  String? id;
  int? likes;
  List? likers;
  int? commentCount;
  String? ownerName;
  String? ownerId;
  String? date = DateFormat('MMM d, kk:mm').format(DateTime.now()).toString();

  PostService({
    this.likers,
    this.commentCount,
    this.id,
    this.post,
    this.likes,
    this.ownerName,
    this.ownerId,
  });

  addPost() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      var addNewPost =
          await FirebaseFirestore.instance.collection('posts').add({
        'post': post,
        'likes': likes,
        'likers': [],
        'timestamp': FieldValue.serverTimestamp(),
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

  updatePost() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      var editPost =
          await FirebaseFirestore.instance.collection('posts').doc(id).update({
        'post': post,
      });
    } catch (e) {
      print('Failed to create a post.');
      print(e);
    }
  }

  deletePost() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      var deletePost =
          await FirebaseFirestore.instance.collection('posts').doc(id).delete();
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
