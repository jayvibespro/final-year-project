import 'package:cloud_firestore/cloud_firestore.dart';

class LikeServices {
  String id;
  String userId;

  int like;

  LikeServices({
    required this.id,
    required this.userId,
    required this.like,
  });

  addLike() async {
    var post = await FirebaseFirestore.instance;

    post.collection('posts').doc(id).update({'likes': like + 1});

    post.collection('posts').doc(id).collection('likers').add({
      'user_id': userId,
      'value': true,
    });
  }

  disLike() async {
    var post = await FirebaseFirestore.instance;

    post.collection('posts').doc(id).update({'likes': like - 1});

    post.collection('posts').doc(id).collection('likers').add({
      'user_id': userId,
      'value': false,
    });
  }
}
