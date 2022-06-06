import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class LikeServices {
  String id;
  String userId;
  int like;
  BuildContext context;

  LikeServices({
    required this.context,
    required this.id,
    required this.userId,
    required this.like,
  });

  void _showBasicsFlash({
    Duration? duration,
    flashStyle = FlashBehavior.floating,
    String? message,
    String? actionText,
    Function()? actionFunction,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Flash(
            controller: controller,
            behavior: flashStyle,
            position: FlashPosition.bottom,
            boxShadows: kElevationToShadow[1],
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.grey[50],
            margin: MediaQuery.of(context).size.width <= 768
                ? const EdgeInsets.symmetric(horizontal: 0)
                : const EdgeInsets.symmetric(horizontal: 300),
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              content: Center(child: Text(message!)),
              actions: [
                TextButton(
                    onPressed: actionFunction, child: Text('$actionText'))
              ],
            ),
          ),
        );
      },
    );
  }

  addLike() async {
    var post = await FirebaseFirestore.instance.collection('posts');

    post.doc(id).get().then((value) {
      if (!value.data()!['likers'].contains(userId)) {
        post.doc(id).update({'likes': like + 1});

        post.doc(id).update({
          'likers': FieldValue.arrayUnion([userId]),
        });
        _showBasicsFlash(
          duration: const Duration(seconds: 4),
          message: 'Post successfully added to your likes collection.',
        );
      } else {
        _showBasicsFlash(
          duration: const Duration(seconds: 4),
          message: 'You already have liked this post.',
          actionText: 'Ok',
          actionFunction: disLike(),
        );

        return;
      }
    });
  }

  disLike() async {
    var post = await FirebaseFirestore.instance.collection('posts');

    post.doc(id).update({'likes': like - 1});

    post.doc(id).update({
      'likers': FieldValue.arrayRemove([userId]),
    });

    _showBasicsFlash(
        duration: const Duration(seconds: 4),
        message: 'Post successfully removed from your likes collection.',
        actionText: 'Ok');
  }
}
