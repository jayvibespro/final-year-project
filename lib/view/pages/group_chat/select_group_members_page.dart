import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/selected_members.dart';
import 'package:finalyearproject/services/group_chat_services.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_chat_page.dart';
import '../login_page.dart';

class SelectGroupMembers extends StatefulWidget {
  SelectGroupMembers({
    Key? key,
    required this.groupName,
    required this.groupDescription,
    required this.members,
  }) : super(key: key);

  String groupName;
  String groupDescription;
  List<LoadedMembers> members;

  @override
  State<SelectGroupMembers> createState() => _SelectGroupMembersState();
}

class _SelectGroupMembersState extends State<SelectGroupMembers> {
  bool isHover = false;

  List<String> groupMembersIds = [];
  List<MembersSelected> selectedMembers = [];

  isSelected() {
    if (selectedMembers == []) {
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController _searchController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
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
                    child: const Center(child: Text("Profile"))),
                value: 4,
              ),
              const PopupMenuItem(
                child: Center(child: Text("Settings")),
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
                    child: const Center(child: Text("LogOut"))),
                value: 6,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.members.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: CheckboxListTile(
                            title: Text('${widget.members[index].memberName}'),
                            subtitle:
                                Text('${widget.members[index].memberEmail}'),
                            value: widget.members[index].memberValue,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.members[index].memberValue = value!;
                              });
                              groupMembersIds
                                  .add(widget.members[index].memberId);
                              if (widget.members[index].memberValue == true) {
                                selectedMembers.add(MembersSelected(
                                  memberId: widget.members[index].memberId,
                                  memberImage:
                                      widget.members[index].memberImage,
                                ));
                              } else if (widget.members[index].memberValue ==
                                  false) {
                                setState(() {
                                  selectedMembers.removeWhere((element) =>
                                      element.memberId ==
                                      widget.members[index].memberId);
                                  groupMembersIds
                                      .remove(widget.members[index].memberId);
                                });
                              }
                            },
                            secondary: const Icon(Icons.person),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 16, bottom: 16),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: selectedMembers.length,
                      itemBuilder: (context, index) {
                        MembersSelected? userSelected = selectedMembers[index];

                        return Stack(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 60,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.members.forEach((element) {
                                      if (element.memberId ==
                                          userSelected.memberId) {
                                        element.memberValue = false;
                                      }
                                    });
                                    selectedMembers.remove(userSelected);
                                    groupMembersIds
                                        .remove(userSelected.memberId);
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[50],
                                  radius: 20,
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ),
                              ),
                              bottom: 0,
                              right: 0,
                            ),
                          ],
                        );
                      }),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                            (route) => false);
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
                      onPressed: () {
                        if (groupMembersIds == []) {
                          return;
                        } else {
                          groupMembersIds.add(auth.currentUser!.uid);
                          GroupChatServices(
                            members: groupMembersIds,
                            groupDescription: widget.groupDescription,
                            groupName: widget.groupName,
                            groupAdmin: auth.currentUser!.uid,
                            groupImage: '',
                          ).createGroup();
                        }
                        groupMembersIds = [];

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                            (route) => false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Done'),
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
