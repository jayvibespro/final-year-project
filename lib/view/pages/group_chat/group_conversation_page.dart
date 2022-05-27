import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_chat_model.dart';
import 'package:finalyearproject/view/pages/group_chat/group_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupConversationPage extends StatefulWidget {
  const GroupConversationPage({Key? key}) : super(key: key);

  @override
  State<GroupConversationPage> createState() => _GroupConversationState();
}

class _GroupConversationState extends State<GroupConversationPage> {
  String? groupSearchString = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<GroupChatConversationModel>> groupChatConversationStream() {
    if (groupSearchString == null || groupSearchString == '') {
      try {
        return _db
            .collection('group_chat')
            .where('members', arrayContains: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<GroupChatConversationModel> dataFromFireStore =
              <GroupChatConversationModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore
                .add(GroupChatConversationModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db
            .collection('group_chat')
            .where('members', arrayContains: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<GroupChatConversationModel> dataFromFireStore =
              <GroupChatConversationModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['group_name']
                .toLowerCase()
                .startsWith(groupSearchString?.toLowerCase())) {
              dataFromFireStore.add(
                  GroupChatConversationModel.fromDocumentSnapshot(doc: doc));
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
    return StreamBuilder<List<GroupChatConversationModel>>(
      stream: groupChatConversationStream(),
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
                GroupChatConversationModel? groupConversationSnapshot =
                    snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('${groupConversationSnapshot.groupName}'),
                        subtitle:
                            Text('${groupConversationSnapshot.lastMessage}'),
                        leading: const Icon(Icons.group),
                        trailing: Text('${groupConversationSnapshot.lastDate}'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupChatPage(
                                        groupChatConversationModel:
                                            groupConversationSnapshot,
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
    );
  }
}
