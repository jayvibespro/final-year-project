import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/posts_model.dart';
import 'package:finalyearproject/services/like_services.dart';
import 'package:finalyearproject/services/post_service.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'comments_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool isLike = false;

  final TextEditingController _postController = TextEditingController();
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<PostsModel>> postStream() {
    try {
      return _db
          .collection("posts")
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<PostsModel> dataFromFireStore = <PostsModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(PostsModel.fromDocumentSnapshot(doc: doc));

          _db
              .collection('posts')
              .doc(PostsModel.fromDocumentSnapshot(doc: doc).id)
              .collection('likers')
              .where('user_id', isEqualTo: auth.currentUser?.uid)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              if (element.data()['value'] == true) {
                isLike = true;
              } else {
                isLike = false;
              }
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
                              padding: _screenSize < _tabletScreenSize
                                  ? const EdgeInsets.all(8)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFF7F9F9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          userId: auth
                                                              .currentUser!.uid)
                                                      .addLike();
                                                },
                                                icon: Icon(
                                                  isLike
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text('${postSnapshot.ownerName}'),
                                          const Icon(Icons.person)
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
                                      child: Text("${postSnapshot.post}"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(
                                            child: Text("${postSnapshot.date}"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
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
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: () {
                  addAdvanceBottomSheets(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Create new post'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addAdvanceBottomSheets(context) {
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
                        'Create your post.',
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
                            date: '12/07/2022',
                            likes: 0,
                            commentCount: 0,
                          ).addPost();

                          setState(() {
                            _postController.clear();
                          });

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Add Post'),
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
}

class PostsPageForMobile extends StatefulWidget {
  PostsPageForMobile({Key? key}) : super(key: key);

  @override
  State<PostsPageForMobile> createState() => _PostsPageForMobileState();
}

class _PostsPageForMobileState extends State<PostsPageForMobile> {
  bool isLike = false;

  final TextEditingController _postController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<PostsModel>> postStream() {
    try {
      return _db
          .collection("posts")
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<PostsModel> dataFromFireStore = <PostsModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(PostsModel.fromDocumentSnapshot(doc: doc));

          _db
              .collection('posts')
              .doc(PostsModel.fromDocumentSnapshot(doc: doc).id)
              .collection('likers')
              .where('user_id', isEqualTo: auth.currentUser?.uid)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              if (element.data()['value'] == true) {
                isLike = true;
              } else {
                isLike = false;
              }
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
      appBar: BaseAppBar(appBar: AppBar()),
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
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFF7F9F9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                onPressed: () async {
                                                  setState(() {
                                                    isLike = !isLike;
                                                  });
                                                  LikeServices(
                                                          id: postSnapshot.id,
                                                          like: postSnapshot
                                                              .likes,
                                                          userId: auth
                                                              .currentUser!.uid)
                                                      .addLike();
                                                },
                                                icon: Icon(
                                                  isLike
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text('${postSnapshot.ownerName}'),
                                          const Icon(Icons.person)
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                      child: Text("${postSnapshot.post}"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("${postSnapshot.date}"),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  addAdvanceBottomSheets(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Create new post'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addAdvanceBottomSheets(context) {
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
                        'Create your post.',
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
                            date: '12/07/2022',
                            likes: 0,
                            commentCount: 0,
                          ).addPost();

                          setState(() {
                            _postController.clear();
                          });

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Add Post'),
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
}
