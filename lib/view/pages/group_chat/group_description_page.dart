import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_description_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Student {
  String name;
  int age;

  Student({
    required this.name,
    required this.age,
  });
}

class GroupDescriptionPage extends StatefulWidget {
  GroupDescriptionPage({Key? key, required this.groupId}) : super(key: key);

  String groupId;

  @override
  State<GroupDescriptionPage> createState() => _GroupDescriptionPageState();
}

class _GroupDescriptionPageState extends State<GroupDescriptionPage> {
  bool isHover = false;
  final _db = FirebaseFirestore.instance;

  List<UserModel> groupMembers = <UserModel>[];

  Future<List<GroupDescriptionModel>> groupDescriptionFuture() {
    try {
      return _db
          .collection('group_chat')
          .where('group_id', isEqualTo: widget.groupId)
          .get()
          .then((element) {
        final List<GroupDescriptionModel> dataFromFireStore =
            <GroupDescriptionModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(GroupDescriptionModel.fromDocumentSnapshot(doc: doc));
        }
        dataFromFireStore.forEach((element) {
          element.members.forEach((id) async {
            await _db
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

  Stream<List<UserModel>> userStream() {
    try {
      return _db.collection("users").snapshots().map((element) {
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
    final List<UserModel> loadedMembers = groupMembers;
    const _tabletScreenWidth = 768;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _screenWidth < _tabletScreenWidth ? const CustomDrawer(): const SizedBox(),
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
          child: FutureBuilder<List<GroupDescriptionModel>>(
            future: groupDescriptionFuture(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred...'),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      GroupDescriptionModel descriptionSnapshot =
                          snapshot.data![index];
                      return Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Icon(
                              Icons.group,
                              size: 60,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: Text(
                              '${descriptionSnapshot.groupName}',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: Text(
                              '${descriptionSnapshot.groupDescription}',
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: 32, right: 32),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Center(
                            child: Text(
                              'Group members count: ${descriptionSnapshot.members.length}',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 600,
                          child: StreamBuilder<List<UserModel>>(
                            stream: userStream(),
                            builder: (context, snapshot) {
                              UserModel? userSnapshot = snapshot.data![index];
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: ListTile(
                                          title: Text('${userSnapshot.name}'),
                                          subtitle:
                                              Text('${userSnapshot.email}'),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: 32, right: 32),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Delete group'),
                            ),
                          ),
                        ),
                      ]);
                    });
              } else {
                return const Center(
                  child: Text('An error occurred...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
