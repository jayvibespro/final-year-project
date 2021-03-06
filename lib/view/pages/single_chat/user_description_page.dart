import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/comments_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:flutter/material.dart';

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
    const _tabletScreenWidth = 768;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomDrawer(),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
    final _screenWidth = MediaQuery.of(context).size.width;
    const _tabletScreenWidth = 768;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: _screenWidth < _tabletScreenWidth
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal:
                                  _screenWidth < _tabletScreenWidth ? 8 : 32),
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
