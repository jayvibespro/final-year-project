import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chat_room.dart';
import '../login_page.dart';

class SelectReceiverPage extends StatefulWidget {
  const SelectReceiverPage({Key? key}) : super(key: key);

  @override
  State<SelectReceiverPage> createState() => _SelectReceiverPageState();
}

class _SelectReceiverPageState extends State<SelectReceiverPage> {
  bool isHover = false;
  String receiverName = "Receiver's name";

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> userStream() {
    try {
      return _db
          .collection('users')
          .where('user_id', isNotEqualTo: auth.currentUser?.uid)
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search user...',
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<UserModel>>(
                  stream: userStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data Loaded...'),
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
                            UserModel? userSnapshot = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text('${userSnapshot.name}'),
                                  subtitle: Text('${userSnapshot.email}'),
                                  leading: const Icon(Icons.person),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type message...',
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _messageController.clear();
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('send'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
