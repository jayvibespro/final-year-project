import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
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
      drawer: const CustomDrawer(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        width: double.infinity,
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                                vertical: 4.0, horizontal: 8),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: ListTile(
                                title: Text('${userSnapshot.name}'),
                                subtitle: Text('${userSnapshot.email}'),
                                leading: const Icon(Icons.person),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
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
              padding: const EdgeInsets.all(8.0),
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
    );
  }
}
