import 'package:flutter/material.dart';

import '../view/pages/chat_room.dart';
import '../view/pages/login_page.dart';
import '../view/pages/posts/posts_page.dart';
import '../view/pages/profile/edit_profile_page.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                            builder: (context) => const EditProfilePage()));
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
    );
  }
}
