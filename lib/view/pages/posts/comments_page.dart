import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/comments_model.dart';
import 'package:finalyearproject/models/posts_model.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/comments_services.dart';
import '../profile/profile_page.dart';
import '../single_chat/user_description_page.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({Key? key, this.postsModel}) : super(key: key);

  PostsModel? postsModel;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool isHover = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();
  final _db = FirebaseFirestore.instance;

  Stream<List<CommentsModel>> commentStream() {
    try {
      return _db
          .collection("posts")
          .doc(widget.postsModel?.id)
          .collection('comments')
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<CommentsModel> dataFromFireStore = <CommentsModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(CommentsModel.fromDocumentSnapshot(doc: doc));
        }
        print(dataFromFireStore);
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    const _tabletScreenWidth = 768;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _screenWidth < _tabletScreenWidth ? const CustomDrawer(): const SizedBox(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: _screenWidth <= _tabletScreenWidth
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
            : const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  '${widget.postsModel!.post}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<CommentsModel>>(
                  stream: commentStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('An Error Occurred...'),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            CommentsModel commentSnapshot =
                                snapshot.data![index];

                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 32),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${commentSnapshot.ownerName}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const Text(
                                                    'Mwananyamala, Dar Es Salaam',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            '12/05/2022, 12:09 PM',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12),
                                          ),
                                          const Icon(
                                              Icons.keyboard_arrow_right),
                                        ],
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 0),
                                        child:
                                            Text('${commentSnapshot.comment}'),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (commentSnapshot.ownerId ==
                                    _auth.currentUser?.uid) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilePage()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommentUserDescriptionPage(
                                                commentsModel:
                                                    commentSnapshot)),
                                  );
                                }
                              },
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('An Error Occurred...'),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                            hintText: 'Comment...',
                            label: Text('Comment'),
                            filled: true,
                            border: InputBorder.none,
                            fillColor: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var countInt = await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postsModel!.id)
                            .get();

                        int count = 1;
                        setState(() {
                          count = countInt.data()!['comment_count'] + 1;
                        });

                        print(count);

                        CommentService(
                          date: '22/07/2022',
                          postId: widget.postsModel!.id,
                          comment: _commentController.text,
                          commentCount: count,
                        ).addComment();
                        _commentController.clear();

                        setState(() {});
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Share'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
