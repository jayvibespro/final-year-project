import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/single_chat_model.dart';
import 'package:finalyearproject/services/single_chat_services.dart';
import 'package:finalyearproject/view/pages/single_chat/user_description_page.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleChatMessagesPage extends StatefulWidget {
  SingleChatMessagesPage({Key? key, required this.singleChatConversationModel})
      : super(key: key);

  SingleChatConversationModel? singleChatConversationModel;

  @override
  State<SingleChatMessagesPage> createState() => _SingleChatMessagesPageState();
}

class _SingleChatMessagesPageState extends State<SingleChatMessagesPage> {
  bool isHover = false;

  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<SingleChatMessagesModel>> singleChatMessagesStream() {
    try {
      return _db
          .collection('single_chat')
          .doc(widget.singleChatConversationModel?.id)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<SingleChatMessagesModel> dataFromFireStore =
            <SingleChatMessagesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(SingleChatMessagesModel.fromDocumentSnapshot(doc: doc));
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
        padding: _screenWidth <= _tabletScreenWidth
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
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFCCEEF9),
                    ),
                    height: 100,
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
                                Icons.person,
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
                                    '${widget.singleChatConversationModel?.receiverName}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '${widget.singleChatConversationModel?.receiverEmail}',
                                    style:
                                        const TextStyle(color: Colors.black54),
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
                          builder: (context) => ChatUserDescriptionPage(
                                receiverId: widget
                                    .singleChatConversationModel!.receiverId,
                              )));
                },
              ),
              Expanded(
                child: StreamBuilder<List<SingleChatMessagesModel>>(
                  stream: singleChatMessagesStream(),
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
                            SingleChatMessagesModel? messageSnapshot =
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
                        SingleChatServices(
                          id: widget.singleChatConversationModel?.id,
                          message: _messageController.text,
                          receiverImage:
                              widget.singleChatConversationModel?.receiverImage,
                          receiverEmail:
                              widget.singleChatConversationModel?.receiverEmail,
                          receiverName:
                              widget.singleChatConversationModel?.receiverName,
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
