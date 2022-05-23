import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/comments_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class ChatUserDescriptionPage extends StatefulWidget {
  ChatUserDescriptionPage({
    Key? key,
    this.receiverId,
  }) : super(key: key);

  String? receiverId;

  @override
  State<ChatUserDescriptionPage> createState() =>
      _ChatUserDescriptionPageState();
}

class _ChatUserDescriptionPageState extends State<ChatUserDescriptionPage> {
  bool isHover = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> userDetailsStream() {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: widget.receiverId)
          .snapshots()
          .map((element) {
        final List<UserModel> dataFromFireStore = <UserModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: const [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save the future",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PostsPage(title: 'Save the Future')),
                );
              },
              onHover: (value) {
                setState(() {
                  isHover = value;
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.black, fontSize: (isHover) ? 16 : 14),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('About us'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatRoomPage()),
              );
            },
            child: const Text('Chatroom'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Stories'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Reports'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Challenges'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Discover'),
          ),
          const SizedBox(
            width: 100,
          ),
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                value: 1,
              ),
              const PopupMenuItem(
                child: Center(child: Text("Sarah Thomas")),
                value: 2,
              ),
              const PopupMenuItem(
                child: Divider(),
                value: 3,
              ),
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                    },
                    child: const Center(child: Text("Profile"))),
                value: 4,
              ),
              const PopupMenuItem(
                child: Center(child: Text("Settings")),
                value: 5,
              ),
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: const Center(child: Text("LogOut"))),
                value: 6,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: StreamBuilder<List<UserModel>>(
            stream: userDetailsStream(),
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
                      UserModel userDetailsSnapshot = snapshot.data![index];

                      return Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: Text(
                              '${userDetailsSnapshot.name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 16, left: 64, right: 64, bottom: 8),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Phone'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.phone}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.name}'),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Gender'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.gender}'),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Profession'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.profession}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Working facility'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.facility}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Region'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.region}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ]);
                    });
              } else {
                return const Center(
                  child: Text('An Error Occurred...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CommentUserDescriptionPage extends StatefulWidget {
  CommentUserDescriptionPage({
    Key? key,
    this.commentsModel,
  }) : super(key: key);

  CommentsModel? commentsModel;

  @override
  State<CommentUserDescriptionPage> createState() =>
      _CommentUserDescriptionPageState();
}

class _CommentUserDescriptionPageState
    extends State<CommentUserDescriptionPage> {
  bool isHover = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> userDetailsStream() {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: widget.commentsModel?.ownerId)
          .snapshots()
          .map((element) {
        final List<UserModel> dataFromFireStore = <UserModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: const [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save the future",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PostsPage(title: 'Save the Future')),
                );
              },
              onHover: (value) {
                setState(() {
                  isHover = value;
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.black, fontSize: (isHover) ? 16 : 14),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('About us'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatRoomPage()),
              );
            },
            child: const Text('Chatroom'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Stories'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Reports'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Challenges'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Discover'),
          ),
          const SizedBox(
            width: 100,
          ),
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                value: 1,
              ),
              const PopupMenuItem(
                child: Center(child: Text("Sarah Thomas")),
                value: 2,
              ),
              const PopupMenuItem(
                child: Divider(),
                value: 3,
              ),
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                    },
                    child: const Center(child: Text("Profile"))),
                value: 4,
              ),
              const PopupMenuItem(
                child: Center(child: Text("Settings")),
                value: 5,
              ),
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: const Center(child: Text("LogOut"))),
                value: 6,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: StreamBuilder<List<UserModel>>(
            stream: userDetailsStream(),
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
                      UserModel userDetailsSnapshot = snapshot.data![index];

                      return Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: Text(
                              '${userDetailsSnapshot.name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 16, left: 64, right: 64, bottom: 8),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Phone'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.phone}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.name}'),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Gender'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.gender}'),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Profession'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.profession}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Working facility'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.facility}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Region'),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text('${userDetailsSnapshot.region}')
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ]);
                    });
              } else {
                return const Center(
                  child: Text('An Error Occurred...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
