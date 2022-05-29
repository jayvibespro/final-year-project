import 'package:cloud_firestore/cloud_firestore.dart';

class LikeServices {
  String id;
  String userId;
  int like;
  List likers;

  LikeServices({
    required this.likers,
    required this.id,
    required this.userId,
    required this.like,
  });

  addLike() async {
    var post = await FirebaseFirestore.instance.collection('posts');

    post.doc(id).get().then((value) {
      if (!value.data()!['likers'].contains(userId)) {
        post.doc(id).update({'likes': like + 1});

        post.doc(id).update({
          // 'likers': userId,
        });
      } else {
        return;
      }
    });
  }

  disLike() async {
    var post = await FirebaseFirestore.instance.collection('posts');

    post.doc(id).update({'likes': like - 1});

    post.doc(id).update({
      // 'likers': userId,
    });
  }
}
