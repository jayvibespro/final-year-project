import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: EdgeInsets.all(8),
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
              child: Center(
                child: Text("Sarah Thomas"),
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
                    AuthServices(email: '', password: '').logout();
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

  // @override
  // Size get preferredSize => Size.fromHeight(widget.appBar.preferredSize.height);
}
