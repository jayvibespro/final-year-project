import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/profile/mobile_profile_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:finalyearproject/view/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const BaseAppBar({
    required this.appBar,
  });

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  // @override
  // TODO: implement preferredSize
  // Size get preferredSize => throw UnimplementedError();
}

class _BaseAppBarState extends State<BaseAppBar> {
  String dropdownValue = 'Home';

  final _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<UserModel>> userStream() {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: auth.currentUser!.uid)
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
    const _laptopScreenWidth = 1024;
    const _tabletScreen = 768;
    final _screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      leading: _screenWidth < _tabletScreen
          ? IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black87,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      elevation: _screenWidth < _tabletScreen ? 2 : 0,
      title: _screenWidth < _tabletScreen
          ? const Text('')
          : Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                _screenWidth <= _laptopScreenWidth
                    ? const Text('')
                    : const Text(
                        "Save the future",
                        style: TextStyle(color: Colors.black),
                      ),
              ],
            ),
      actions: [
        _screenWidth < _tabletScreen
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.blue.shade200,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black54),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });

                        if (dropdownValue == 'Chatroom') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoomPage()),
                          );
                        }
                      },
                      items: <String>[
                        'Home',
                        'About us',
                        'Chatroom',
                        'Stories',
                        'Report',
                        'Challenges',
                        'Discover',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            : const SizedBox(
                width: 50,
              ),
        _screenWidth < _tabletScreen
            ? const SizedBox()
            : Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Home'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('About us'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ChatRoomPage()),
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
                ],
              ),
        const SizedBox(
          width: 100,
        ),
        PopupMenuButton(
          color: Colors.white,
          child: StreamBuilder<List<UserModel>>(
            stream: userStream(),
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
                var userSnapshot = snapshot.data!;
                String name = '';
                userSnapshot.forEach((element) {
                  name = element.name;
                });

                return CircleAvatar(
                  backgroundColor: Colors.grey[50],
                  radius: 30,
                  child: Text(
                    '${name[0].toUpperCase()}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return const Center(
                  child: Text('An Error Occurred...'),
                );
              }
            },
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
            PopupMenuItem(
              child: Center(
                child: StreamBuilder<List<UserModel>>(
                  stream: userStream(),
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
                      var userSnapshot = snapshot.data!;
                      String name = '';
                      userSnapshot.forEach((element) {
                        name = element.name;
                      });

                      return Text('${name}');
                    } else {
                      return const Center(
                        child: Text('An Error Occurred...'),
                      );
                    }
                  },
                ),
              ),
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
                          builder: (context) =>
                              _screenWidth < _laptopScreenWidth
                                  ? const MobileProfilePage()
                                  : const ProfilePage()));
                },
                child: const Center(
                  child: Text('Profile'),
                ),
              ),
              value: 4,
            ),
            PopupMenuItem(
              child: GestureDetector(
                  onTap: () {
                    AuthServices(email: '', password: '').logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _screenWidth < _tabletScreen
                                ? const SignInScreen()
                                : LoginPage()),
                        (route) => false);
                  },
                  child: const Center(child: Text("LogOut"))),
              value: 5,
            ),
          ],
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  // @override
  // Size get preferredSize => Size.fromHeight(widget.appBar.preferredSize.height);
}
