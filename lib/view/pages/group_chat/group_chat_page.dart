import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_chat_model.dart';
import 'package:finalyearproject/models/group_description_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/group_chat_services.dart';
import 'package:finalyearproject/view/pages/group_chat/group_description_page.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  List<UserModel> groupMembers = <UserModel>[];

  Future getMembers() async {
    try {
      return await _db
          .collection('group_chat')
          .where('group_id',
              isEqualTo: widget.groupChatConversationModel!.groupId)
          .get()
          .then((element) {
        final List<GroupDescriptionModel> dataFromFireStore =
            <GroupDescriptionModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(GroupDescriptionModel.fromDocumentSnapshot(doc: doc));
        }
        dataFromFireStore.forEach((element) {
          element.members.forEach((id) {
            _db
                .collection('users')
                .where('user_id', isEqualTo: id)
                .get()
                .then((value) {
              for (final DocumentSnapshot<Map<String, dynamic>> doc
                  in value.docs) {
                groupMembers.add(UserModel.fromDocumentSnapshot(doc: doc));
              }
            });
          });
        });
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupChatMessagesModel>> groupChatMessagesStream() {
    try {
      return _db
          .collection('group_chat')
          .doc(widget.groupChatConversationModel?.id)
          .collection('messages')
          .orderBy('timestamp', descending: true)
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
    const _tabletScreenWidth = 768;
    const _laptopScreenWidth = 1024;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _screenWidth < _tabletScreenWidth
          ? const CustomDrawer()
          : const SizedBox(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: _screenWidth <= _laptopScreenWidth
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
            : const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Padding(
                  padding: _screenWidth <= _laptopScreenWidth
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(32),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: _screenWidth <= _laptopScreenWidth
                          ? BorderRadius.circular(0)
                          : BorderRadius.circular(20),
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
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: _screenWidth <= _laptopScreenWidth
                                          ? _screenWidth * 0.7
                                          : 400,
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
                  getMembers;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupDescriptionPage(
                              groupId:
                                  widget.groupChatConversationModel!.groupId,
                            )),
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
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 32, right: 32),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 32),
                                  child: Text(
                                    '${messageSnapshot.date}',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 10),
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
                padding: const EdgeInsets.all(16.0),
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
