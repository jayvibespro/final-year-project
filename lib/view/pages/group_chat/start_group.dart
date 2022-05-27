import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/selected_members.dart';
import 'package:finalyearproject/view/pages/group_chat/select_group_members_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class StartGroup extends StatefulWidget {
  const StartGroup({Key? key}) : super(key: key);

  @override
  State<StartGroup> createState() => _StartGroupState();
}

class _StartGroupState extends State<StartGroup> {


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

  TextEditingController? base64;

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
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


  @override
  Widget build(BuildContext context) {
    const _tabletScreenWidth = 768;
      final _screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        drawer: const CustomDrawer(),
        appBar: BaseAppBar(appBar: AppBar()),
        body: ListView(
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
                          Navigator.pop(context);
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
      )
  );}
}