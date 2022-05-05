import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  String? post;
  String? id;
  String? likes;
  String? ownerName;
  String? ownerId;
  String? date;

  PostService({
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
      print('An error occured.');
      print(e);
    }
  }
}
