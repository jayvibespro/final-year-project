import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_chat_model.dart';
import 'package:finalyearproject/services/group_chat_services.dart';
import 'package:finalyearproject/view/pages/group_chat/group_description_page.dart';
import 'package:finalyearproject/view/pages/home_chat_page.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';
import '../profile/profile_page.dart';

class GroupChatPage extends StatefulWidget {
  GroupChatPage({Key? key, required this.groupChatConversationModel})
      : super(key: key);
  GroupChatConversationModel? groupChatConversationModel;
  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  bool isHover = false;

  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<GroupChatMessagesModel>> groupChatMessagesStream() {
    try {
      return _db
          .collection('group_chat')
          .doc(widget.groupChatConversationModel?.id)
          .collection('messages')
          .snapshots()
          .map((element) {
        final List<GroupChatMessagesModel> dataFromFireStore =
            <GroupChatMessagesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(GroupChatMessagesModel.fromDocumentSnapshot(doc: doc));
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
                MaterialPageRoute(builder: (context) => ChatPage()),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFCCEEF9),
                    ),
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.group,
                                size: 40,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.groupChatConversationModel?.groupName}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: 400,
                                      child: Text(
                                        '${widget.groupChatConversationModel?.groupDescription}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GroupDescriptionPage()),
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<List<GroupChatMessagesModel>>(
                  stream: groupChatMessagesStream(),
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
                          reverse: true,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            GroupChatMessagesModel? messageSnapshot =
                                snapshot.data![index];
                            return Column(
                              crossAxisAlignment: messageSnapshot.senderId ==
                                      auth.currentUser!.uid
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 32),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: messageSnapshot.senderId ==
                                              auth.currentUser!.uid
                                          ? const Color(0xFF82E0AA)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        '${messageSnapshot.message}',
                                        style: TextStyle(
                                            color: messageSnapshot.senderId ==
                                                    auth.currentUser!.uid
                                                ? Colors.white
                                                : Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 32),
                                  child: Text(
                                    '12:12 AM',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
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
                            hintText: 'Message...',
                            filled: true,
                            border: InputBorder.none,
                            fillColor: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        GroupChatServices(
                          id: widget.groupChatConversationModel?.id,
                          message: _messageController.text,
                          date: '04:45 PM',
                          timeStamp: '',
                          senderId: auth.currentUser!.uid,
                        ).sendMessage();

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
              )
            ],
          ),
        ),
      ),
    );
  }
}
