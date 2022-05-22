import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_chat_model.dart';
import 'package:finalyearproject/models/selected_members.dart';
import 'package:finalyearproject/models/single_chat_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/single_chat_services.dart';
import 'package:finalyearproject/view/pages/group_chat/group_chat_page.dart';
import 'package:finalyearproject/view/pages/group_chat/select_group_members_page.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:finalyearproject/view/pages/single_chat/single_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? groupSearchString;
  String? userSearchString;
  String? singleChatSearchString;
  String receiverName = "Receiver's name";
  String receiverId = '';
  String receiverImage = '';
  String receiverEmail = '';
  List<String> singleChatMembers = [];

  bool isHover = false;
  int isChosenWidget = 0;
  final TextEditingController _groupSearchController = TextEditingController();
  final TextEditingController _singleChatSearchController =
      TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  final TextEditingController _singleChatMessageController =
      TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  // List<String> searchIndexList = [];
  //
  // createSearchIndex(String name) {
  //   List<String> splitList = name.split(' ');
  //
  //   for (int i = 0; i < splitList.length; i++) {
  //     for (int j = 0; j < splitList[i].length + i; j++) {
  //       searchIndexList.add(splitList[i].substring(0, j + 1).toLowerCase());
  //     }
  //   }
  // }

  Stream<List<UserModel>> userStream() {
    if (userSearchString == null || userSearchString == '') {
      try {
        return _db
            .collection('users')
            .where('user_id', isNotEqualTo: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<UserModel> dataFromFireStore = <UserModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db
            .collection('users')
            .where('user_id', isNotEqualTo: auth.currentUser?.uid)
            .snapshots()
            .map((element) {
          final List<UserModel> dataFromFireStore = <UserModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['name']
                .toLowerCase()
                .startsWith(userSearchString?.toLowerCase())) {
              dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
            }
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  Stream<List<SingleChatConversationModel>> singleChatConversationStream() {
    if (singleChatSearchString == null || singleChatSearchString == '') {
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
            if (doc.data()!['group_name'].toLowerCase().startsWith(groupSearchString?.toLowerCase())) {
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

  Widget currentWidget() {
    if (isChosenWidget == 0) {
      return StreamBuilder<List<SingleChatConversationModel>>(
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
      );
    } else if (isChosenWidget == 1) {
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
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
                          trailing:
                              Text('${groupConversationSnapshot.lastDate}'),
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
    } else if (isChosenWidget == 2) {
      return Container(
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

                      setState(() {
                        _singleChatMessageController.clear();
                        isChosenWidget = 0;
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
      );
    } else {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 200,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            child: const Center(
                              child: Text('Select image'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16, top: 4),
                            child: TextField(
                              controller: _groupNameController,
                              decoration: const InputDecoration(
                                hintText: 'Name...',
                                label: Text('Group name'),
                                enabledBorder: OutlineInputBorder(
                                    //Outline border type for TextFeild
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 1,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            controller: _groupDescriptionController,
                            maxLines: 9,
                            minLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Group description...',
                              label: Text('Description'),
                              enabledBorder: OutlineInputBorder(
                                  //Outline border type for TextFeild
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 150,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isChosenWidget = 0;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {

                          final FirebaseAuth auth = FirebaseAuth.instance;

                          final _db = FirebaseFirestore.instance;
                          List<LoadedMembers> membersLoaded = [];

                          try {
                            await _db
                                .collection('users')
                                .where('user_id',
                                    isNotEqualTo: auth.currentUser?.uid)
                                .get()
                                .then((value) {
                              value.docs.forEach((element) {
                                membersLoaded.add(LoadedMembers(
                                    memberId: element['user_id'],
                                    memberImage: element['avatar_url'],
                                    memberName: element['name'],
                                    memberEmail: element['email'],
                                    memberValue: false));
                              });
                              return membersLoaded;
                            });
                          } catch (e) {
                            rethrow;
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectGroupMembers(
                                        members: membersLoaded,
                                        groupName: _groupNameController.text,
                                        groupDescription:
                                            _groupDescriptionController.text,
                                      )));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Add members'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  String searchTitle() {
    if (isChosenWidget == 0) {
      return 'Filter chats by name...';
    } else if (isChosenWidget == 1) {
      return 'Filter groups by name...';
    } else {
      return 'Search...';
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
                  child: const Center(
                    child: Text("Profile"),
                  ),
                ),
                value: 4,
              ),
              const PopupMenuItem(
                child: Center(
                  child: Text("Settings"),
                ),
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
                  child: const Center(
                    child: Text("LogOut"),
                  ),
                ),
                value: 6,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: isChosenWidget == 2 || isChosenWidget == 3
                              ? null
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: isChosenWidget == 0
                                            ? _singleChatSearchController
                                            : _groupSearchController,
                                        onChanged: (value) {
                                          if (isChosenWidget == 0) {
                                            setState(() {
                                              singleChatSearchString =
                                                  value.toLowerCase();
                                            });
                                          } else if (isChosenWidget == 1) {
                                            setState(() {
                                              groupSearchString =
                                                  value.toLowerCase();
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: searchTitle(),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _userSearchController.clear();
                                                _groupSearchController.clear();
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // CircleAvatar(
                                    //   radius: 26,
                                    //   backgroundColor: Colors.white,
                                    //   child: IconButton(
                                    //     color: Colors.white,
                                    //     onPressed: () {},
                                    //     icon: const Icon(
                                    //       Icons.search
                                    //       color: Colors.black54,
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isChosenWidget = 0;
                            });
                          },
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isChosenWidget == 0
                                    ? const Color(0xFFD1F2EB)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 84, right: 32),
                                      child: Icon(Icons.person,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      'Chats',
                                      style: TextStyle(
                                          color: isChosenWidget == 0
                                              ? Colors.white
                                              : Colors.black54,
                                          fontSize:
                                              isChosenWidget == 0 ? 20 : 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isChosenWidget = 1;
                            });
                          },
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isChosenWidget == 1
                                    ? const Color(0xFFD1F2EB)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 84, right: 32.0),
                                      child: Icon(
                                        Icons.group,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Groups',
                                      style: TextStyle(
                                          color: isChosenWidget == 1
                                              ? Colors.white
                                              : Colors.black54,
                                          fontSize:
                                              isChosenWidget == 1 ? 20 : 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isChosenWidget = 2;
                            });
                          },
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isChosenWidget == 2
                                    ? const Color(0xFFD1F2EB)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 84, right: 32.0),
                                      child: Icon(Icons.add_comment,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      'Start Chat',
                                      style: TextStyle(
                                          color: isChosenWidget == 2
                                              ? Colors.white
                                              : Colors.black54,
                                          fontSize:
                                              isChosenWidget == 2 ? 20 : 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isChosenWidget = 3;
                            });
                          },
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isChosenWidget == 3
                                    ? const Color(0xFFD1F2EB)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 84, right: 32.0),
                                      child: Icon(
                                        Icons.group_add,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Create group',
                                      style: TextStyle(
                                          color: isChosenWidget == 3
                                              ? Colors.white
                                              : Colors.black54,
                                          fontSize:
                                              isChosenWidget == 3 ? 20 : 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: currentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
