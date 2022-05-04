import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:finalyearproject/view/pages/select_users_page.dart';
import 'package:finalyearproject/widgets/group_tile.dart';
import 'package:finalyearproject/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isHover = false;
  int isChosenWidget = 1;
  final TextEditingController _searchController = TextEditingController();

  Widget currentWidget() {
    if (isChosenWidget == 1) {
      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: const [
          GroupTile(),
          GroupTile(),
          GroupTile(),
          GroupTile(),
          GroupTile(),
        ],
      );
    } else if (isChosenWidget == 2) {
      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: const [
          UserTile(),
          UserTile(),
          UserTile(),
          UserTile(),
          UserTile(),
        ],
      );
    } else {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16, top: 4),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Name...',
                      label: Text('Group name'),
                      enabledBorder: OutlineInputBorder(
                          //Outline border type for TextFeild
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.tealAccent,
                            width: 2,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const TextField(
                  maxLines: 9,
                  minLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Group description...',
                    label: Text('Description'),
                    enabledBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Selected members'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Container(
                    height: 90,
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 50,
                          child: FlutterLogo(
                            size: 45,
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          child: FlutterLogo(
                            size: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectUsers()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Add members'),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Create'),
                          )),
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
    if (isChosenWidget == 1) {
      return 'Search  group...';
    } else if (isChosenWidget == 2) {
      return 'Search user...';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFCCEEF9),
                  ),
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 260,
                            child: Container(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: searchTitle(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // boxShadow: const [
                                //   BoxShadow(
                                //     color: Color.fromRGBO(143, 148, 251, 0.5),
                                //     blurRadius: 5.0,
                                //     offset: Offset(2, 6),
                                //   ),
                                // ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Groups',
                                style: TextStyle(
                                    color: isChosenWidget == 1
                                        ? Colors.blueGrey
                                        : Colors.black,
                                    fontSize: isChosenWidget == 1 ? 20 : 16),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isChosenWidget = 1;
                              });
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Users',
                                style: TextStyle(
                                    color: isChosenWidget == 2
                                        ? Colors.blueGrey
                                        : Colors.black,
                                    fontSize: isChosenWidget == 2 ? 20 : 16),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isChosenWidget = 2;
                              });
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Create group',
                                style: TextStyle(
                                    color: isChosenWidget == 3
                                        ? Colors.blueGrey
                                        : Colors.black,
                                    fontSize: isChosenWidget == 3 ? 20 : 16),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isChosenWidget = 3;
                              });
                            },
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
