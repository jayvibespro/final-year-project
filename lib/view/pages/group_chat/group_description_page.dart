import 'package:finalyearproject/view/pages/home_chat_page.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class GroupDescriptionPage extends StatefulWidget {
  const GroupDescriptionPage({Key? key}) : super(key: key);

  @override
  State<GroupDescriptionPage> createState() => _GroupDescriptionPageState();
}

class _GroupDescriptionPageState extends State<GroupDescriptionPage> {
  bool isHover = false;
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
                    child: Center(child: Text("Profile"))),
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
          child: ListView(children: [
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
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  'Majamaa Wauguzi',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, left: 32, right: 32),
              child: Divider(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Center(
                child: Text(
                  'Members: 56',
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const ListTile(
                  title: Text('Millenium Malamla'),
                  subtitle: Text('milleniumanthony@gmail.com'),
                  leading: Icon(Icons.person),
                  trailing: Text('Admin'),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const ListTile(
                  title: Text('Minja Hassan'),
                  subtitle: Text('minja@gmail.com'),
                  leading: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const ListTile(
                  title: Text('Masanja Sanjai'),
                  subtitle: Text('masanja@gmail.com'),
                  leading: Icon(Icons.person),
                  trailing: Text('Admin'),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const ListTile(
                  title: Text('Samia Minja Hassan'),
                  subtitle: Text('samiahassan@gmail.com'),
                  leading: Icon(Icons.person),
                  trailing: Text('Admin'),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const ListTile(
                  title: Text('Mrisho Mpoto'),
                  subtitle: Text('mpoto001@gmail.com'),
                  leading: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, left: 32, right: 32),
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
          ]),
        ),
      ),
    );
  }
}
