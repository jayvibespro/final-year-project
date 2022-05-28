import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/single_chat_model.dart';
import 'package:finalyearproject/view/pages/single_chat/single_chat_page.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleChatConversation extends StatelessWidget {
  SingleChatConversation({Key? key}) : super(key: key);

  String? singleChatSearchString = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<List<SingleChatConversationModel>> singleChatConversationStream() {
    if (singleChatSearchString == null || singleChatSearchString == '') {
      print('search String value: $singleChatSearchString');
      try {
        return _db
            .collection('single_chat')
            .where('members', arrayContains: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<SingleChatConversationModel> dataFromFireStore =
              <SingleChatConversationModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore.add(
                SingleChatConversationModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db
            .collection('single_chat')
            .where('members', arrayContains: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<SingleChatConversationModel> dataFromFireStore =
              <SingleChatConversationModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['receiver_name']
                .toLowerCase()
                .startsWith(singleChatSearchString?.toLowerCase())) {
              dataFromFireStore.add(
                  SingleChatConversationModel.fromDocumentSnapshot(doc: doc));
            }
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: StreamBuilder<List<SingleChatConversationModel>>(
        stream: singleChatConversationStream(),
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
                  SingleChatConversationModel? userConversationSnapshot =
                      snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          title:
                              Text('${userConversationSnapshot.receiverName}'),
                          subtitle:
                              Text('${userConversationSnapshot.lastMessage}'),
                          leading: const Icon(Icons.person),
                          trailing:
                              Text('${userConversationSnapshot.lastDate}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleChatMessagesPage(
                                          singleChatConversationModel:
                                              userConversationSnapshot,
                                        )));
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
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
    );
  }
}
