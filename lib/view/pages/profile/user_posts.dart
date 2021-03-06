import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/posts_model.dart';
import 'package:finalyearproject/services/like_services.dart';
import 'package:finalyearproject/services/post_service.dart';
import 'package:finalyearproject/view/pages/posts/comments_page.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  bool isLike = false;
  List likers = [];

  final TextEditingController _postController = TextEditingController();
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<PostsModel>> userPostStream() {
    try {
      return _db
          .collection("posts")
          .where('owner_id', isEqualTo: auth.currentUser!.uid)
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<PostsModel> dataFromFireStore = <PostsModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(PostsModel.fromDocumentSnapshot(doc: doc));

          _db
              .collection('posts')
              .doc(PostsModel.fromDocumentSnapshot(doc: doc).id)
              .get()
              .then((value) {
            value.data()!['likers'].forEach((element) {
              likers
                  .add({PostsModel.fromDocumentSnapshot(doc: doc).id: element});
            });
          });
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size.width;
    const _tabletScreenSize = 768;
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<PostsModel>>(
                stream: userPostStream(),
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
                          PostsModel postSnapshot = snapshot.data![index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                          postsModel: postSnapshot,
                                        )),
                              );
                            },
                            child: Padding(
                              padding: _screenSize < _tabletScreenSize
                                  ? const EdgeInsets.all(8)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFF7F9F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: _screenSize < _tabletScreenSize
                                            ? const EdgeInsets.all(8.0)
                                            : const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${postSnapshot.likes}',
                                                  style: TextStyle(
                                                      fontSize: _screenSize <
                                                              _tabletScreenSize
                                                          ? 16
                                                          : 26,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: _screenSize <
                                                          _tabletScreenSize
                                                      ? 10
                                                      : 20,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLike = !isLike;
                                                    });
                                                    LikeServices(
                                                            id: postSnapshot.id,
                                                            like: postSnapshot
                                                                .likes,
                                                            context: context,
                                                            userId: auth
                                                                .currentUser!
                                                                .uid)
                                                        .addLike();
                                                  },
                                                  icon: Icon(
                                                    likers.contains({
                                                      postSnapshot.id:
                                                          auth.currentUser!.uid
                                                    })
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(child: SizedBox()),
                                            Text(
                                              '${postSnapshot.ownerName}',
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(Icons.person),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                editPostBottomSheets(
                                                  context,
                                                  postSnapshot.id,
                                                  postSnapshot.post,
                                                );
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                deletePostBottomSheets(
                                                    context, postSnapshot.id);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Divider(),
                                      ),
                                      Padding(
                                        padding: _screenSize < _tabletScreenSize
                                            ? const EdgeInsets.all(8)
                                            : const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                        child: Text(
                                          "${postSnapshot.post}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Text(
                                                "${postSnapshot.date}",
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Text(
                                                "Comments: ${postSnapshot.commentCount}",
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
          ],
        ),
      ),
    );
  }

  editPostBottomSheets(context, String postId, String post) {
    _postController.text = post;
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenSize = 768;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: _screenWidth <= _tabletScreenSize
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Edit post.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: TextField(
                          controller: _postController,
                          minLines: 5,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText: 'Write here...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 0.5),
                              blurRadius: 5.0,
                              offset: Offset(2, 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          PostService(
                            post: _postController.text,
                            id: postId,
                          ).updatePost();

                          setState(() {
                            _postController.clear();
                          });

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }

  deletePostBottomSheets(context, String postId) {
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenSize = 768;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: _screenWidth <= _tabletScreenSize
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Warning',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                            'One post will be permanently deleted from your posts collection.'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Cancel'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              PostService(
                                id: postId,
                              ).deletePost();

                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }
}

class UserPostsPageForMobile extends StatefulWidget {
  UserPostsPageForMobile({Key? key}) : super(key: key);

  @override
  State<UserPostsPageForMobile> createState() => _UserPostsPageForMobileState();
}

class _UserPostsPageForMobileState extends State<UserPostsPageForMobile> {
  bool isLike = false;

  List likers = [];

  final TextEditingController _postController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<PostsModel>> postStream() {
    try {
      return _db
          .collection("posts")
          .where('owner_id', isEqualTo: auth.currentUser!.uid)
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<PostsModel> dataFromFireStore = <PostsModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(PostsModel.fromDocumentSnapshot(doc: doc));

          _db
              .collection('posts')
              .doc(PostsModel.fromDocumentSnapshot(doc: doc).id)
              .get()
              .then((value) {
            value.data()!['likers'].forEach((element) {
              likers
                  .add({PostsModel.fromDocumentSnapshot(doc: doc).id: element});
            });
          });
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenWidth = 768;
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<PostsModel>>(
                stream: postStream(),
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
                          PostsModel postSnapshot = snapshot.data![index];

                          return InkWell(
                            child: Padding(
                              padding: _screenWidth <= _tabletScreenWidth
                                  ? const EdgeInsets.all(4)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFF7F9F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${postSnapshot.likes}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    LikeServices(
                                                            context: context,
                                                            id: postSnapshot.id,
                                                            like: postSnapshot
                                                                .likes,
                                                            userId: auth
                                                                .currentUser!
                                                                .uid)
                                                        .addLike();
                                                  },
                                                  icon: Icon(
                                                    likers.contains({
                                                      postSnapshot.id:
                                                          auth.currentUser!.uid
                                                    })
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    '${postSnapshot.ownerName}'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(Icons.person)
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                editPostBottomSheets(
                                                    context,
                                                    postSnapshot.id,
                                                    postSnapshot.post);
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                deletePostBottomSheets(
                                                    context, postSnapshot.id);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Divider(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 0, 4, 4),
                                        child: Text("${postSnapshot.post}"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child:
                                                  Text("${postSnapshot.date}"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                  "Comments: ${postSnapshot.commentCount}"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                          postsModel: postSnapshot,
                                        )),
                              );
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
          ],
        ),
      ),
    );
  }

  editPostBottomSheets(context, String postId, String post) {
    _postController.text = post;
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenSize = 768;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: _screenWidth <= _tabletScreenSize
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Edit post.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: TextField(
                          controller: _postController,
                          minLines: 5,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText: 'Write here...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 0.5),
                              blurRadius: 5.0,
                              offset: Offset(2, 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          PostService(
                            post: _postController.text,
                            id: postId,
                          ).updatePost();

                          setState(() {
                            _postController.clear();
                          });

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }

  deletePostBottomSheets(context, String postId) {
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenSize = 768;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: _screenWidth <= _tabletScreenSize
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Warning',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                            'One post will be permanently deleted from your posts collection.'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Cancel'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              PostService(
                                id: postId,
                              ).deletePost();

                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }
}
