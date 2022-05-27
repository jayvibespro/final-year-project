import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/group_chat_model.dart';
import 'package:finalyearproject/models/selected_members.dart';
import 'package:finalyearproject/models/single_chat_model.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/single_chat_services.dart';
import 'package:finalyearproject/view/pages/group_chat/select_group_members_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/single_chat/single_chat_page.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../constants/constants_state_values.dart';
import 'group_chat/group_conversation_page.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  String? groupSearchString;
  String? userSearchString;
  String? singleChatSearchString;
  String receiverName = "Receiver's name";
  String receiverId = '';
  String receiverImage = '';
  String receiverEmail = '';
  List<String> singleChatMembers = [];
  String avatarUrl = '';
  ByteData? imageData;
  bool isHover = false;

  TextEditingController? base64;

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

  UploadTask? task;
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadImage() async {
    if (image == null) {
      print('image is null');
    } else {
      final imageName = image?.path;

      final destination = 'images/$imageName';

      var snapshot = await FirebaseStorage.instance
          .ref()
          .child(destination)
          .putFile(image!)
          .whenComplete(() => null);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        avatarUrl = downloadUrl;
      });
      print('IMAGE URL:');
      print(avatarUrl);
    }
  }

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
      return const GroupConversationPage();
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
    } else if (isChosenWidget == 3) {
      const _tabletScreenWidth = 768;
      final _screenWidth = MediaQuery.of(context).size.width;

      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _screenWidth <= _tabletScreenWidth
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
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
                                  width: 160,
                                  height: 160,
                                  child: Center(
                                    child: image != null
                                        ? Text('SELECTED IMAGE: ${image?.path}')
                                        : const Text('Select image'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16, top: 4),
                                child: TextField(
                                  controller: _groupNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Name...',
                                    label: Text('Group name'),
                                    enabledBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
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
                                  child: Center(
                                    child: image != null
                                        ? Text('SELECTED IMAGE: ${image?.path}')
                                        : const Text('Select image'),
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
                                  padding:
                                      const EdgeInsets.only(bottom: 16, top: 4),
                                  child: TextField(
                                    controller: _groupNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Name...',
                                      label: Text('Group name'),
                                      enabledBorder: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Colors.black26,
                                            width: 1,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                          uploadImage();
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
                                        imageUrl: avatarUrl,
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
    } else {
      return const PostsPage(title: 'Life Guard');
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const _laptopScreen = 1024;
    const _tabletScreen = 768;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: _screenWidth < _tabletScreen
          ? const CustomDrawer()
          : const SizedBox(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _screenWidth < _tabletScreen
                ? const SizedBox()
                : Container(
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
                                child: isChosenWidget == 2 ||
                                        isChosenWidget == 3 ||
                                        isChosenWidget == 4
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
                                                } else if (isChosenWidget ==
                                                    1) {
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
                                                      if (isChosenWidget == 0) {
                                                        _singleChatSearchController
                                                            .clear();
                                                      } else if (isChosenWidget ==
                                                          1) {
                                                        _groupSearchController
                                                            .clear();
                                                      } else {
                                                        return;
                                                      }
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                    isChosenWidget = 4;
                                  });
                                },
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isChosenWidget == 4
                                          ? Colors.greenAccent
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: _screenWidth < _laptopScreen
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(Icons.feed,
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  'Feeds',
                                                  style: TextStyle(
                                                      color: isChosenWidget == 4
                                                          ? Colors.white
                                                          : Colors.green,
                                                      fontSize:
                                                          isChosenWidget == 4
                                                              ? 24
                                                              : 18),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 84, right: 32),
                                                  child: Icon(Icons.feed,
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  'Feeds',
                                                  style: TextStyle(
                                                      color: isChosenWidget == 4
                                                          ? Colors.white
                                                          : Colors.green,
                                                      fontSize:
                                                          isChosenWidget == 4
                                                              ? 24
                                                              : 18),
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
                                    isChosenWidget = 0;
                                  });
                                },
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isChosenWidget == 0
                                          ? const Color(0xFFD1F2EB)
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: _screenWidth < _laptopScreen
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4),
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
                                                          isChosenWidget == 0
                                                              ? 20
                                                              : 16),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 84, right: 32),
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
                                                          isChosenWidget == 0
                                                              ? 20
                                                              : 16),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isChosenWidget == 1
                                          ? const Color(0xFFD1F2EB)
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: _screenWidth < _laptopScreen
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4),
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
                                                          isChosenWidget == 1
                                                              ? 20
                                                              : 16),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                          isChosenWidget == 1
                                                              ? 20
                                                              : 16),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isChosenWidget == 2
                                          ? const Color(0xFFD1F2EB)
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: _screenWidth < _laptopScreen
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4),
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
                                                          isChosenWidget == 2
                                                              ? 20
                                                              : 16),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                          isChosenWidget == 2
                                                              ? 20
                                                              : 16),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isChosenWidget == 3
                                          ? const Color(0xFFD1F2EB)
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: _screenWidth < _laptopScreen
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.group_add,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  'Start group',
                                                  style: TextStyle(
                                                      color: isChosenWidget == 3
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize:
                                                          isChosenWidget == 3
                                                              ? 20
                                                              : 16),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                  'Start group',
                                                  style: TextStyle(
                                                      color: isChosenWidget == 3
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize:
                                                          isChosenWidget == 3
                                                              ? 20
                                                              : 16),
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
