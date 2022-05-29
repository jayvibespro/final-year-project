import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/single_chat_services.dart';
import 'package:finalyearproject/view/pages/single_chat/single_chat_conversation_page.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartChatPage extends StatefulWidget {
  const StartChatPage({Key? key}) : super(key: key);

  @override
  State<StartChatPage> createState() => _StartChatPageState();
}

class _StartChatPageState extends State<StartChatPage> {
  String? userSearchString;
  String? singleChatSearchString;
  String receiverName = "Receiver's name";
  String receiverId = '';
  String receiverImage = '';
  String receiverEmail = '';
  List<String> singleChatMembers = [];
  String avatarUrl = '';

  final TextEditingController _singleChatMessageController =
      TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();

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
      drawer: const CustomDrawer(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        color: const Color(0xFFF4F6F7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userSearchController,
                      onChanged: (value) {
                        setState(() {
                          userSearchString = value;
                        });
                      },
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
                        _userSearchController.clear();
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                children: [
                  const Text(
                    'Recipient: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    receiverName,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
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
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text('${userSnapshot.name}'),
                                  subtitle: Text('${userSnapshot.email}'),
                                  leading: const Icon(Icons.person),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  onTap: () {
                                    setState(() {
                                      receiverEmail = userSnapshot.email;
                                      receiverName = userSnapshot.name;
                                      receiverImage = userSnapshot.avatarUrl;
                                      receiverId = userSnapshot.userId;
                                    });
                                  },
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _singleChatMessageController,
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
                    onPressed: () async {
                      String? tempId = '';
                      setState(() {
                        singleChatMembers = [auth.currentUser!.uid, receiverId];
                      });

                      var getChat = await FirebaseFirestore.instance
                          .collection('single_chat')
                          .where('members',
                              arrayContains: auth.currentUser!.uid)
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          if (element.data()['members'].contains(receiverId)) {
                            tempId = element.id;
                          }
                        });
                      });

                      print('receiver ID id $tempId');

                      if (tempId != '') {
                        SingleChatServices(
                          id: tempId,
                          message: _singleChatMessageController.text,
                          receiverName: receiverName,
                          receiverEmail: receiverEmail,
                          receiverImage: receiverImage,
                          date: 'May 17, 02:33',
                          senderId: auth.currentUser!.uid,
                        ).sendMessage();
                      } else {
                        SingleChatServices(
                          members: singleChatMembers,
                          receiverId: receiverId,
                          receiverName: receiverName,
                          receiverEmail: receiverEmail,
                          receiverImage: receiverImage,
                          senderId: auth.currentUser!.uid,
                          message: _singleChatMessageController.text,
                          date: 'May 17, 02:33',
                        ).createChat();
                      }

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleChatConversation()));
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
    );
  }
}
