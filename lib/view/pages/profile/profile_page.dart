import 'package:finalyearproject/view/pages/profile/likes_collection.dart';
import 'package:finalyearproject/view/pages/profile/user_posts.dart';
import 'package:finalyearproject/view/pages/profile/user_profile_info/user_info.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int isChosen = 0;

  Widget currentWidget() {
    if (isChosen == 0) {
      return const UserInformation();
    } else if (isChosen == 1) {
      return const UserPostsPage(title: 'Life Guard');
    } else {
      return const LikesPage(title: 'Life Guard');
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
      backgroundColor: const Color(0xFFF2F3F4),
      appBar: _screenWidth <= _laptopScreen
          ? BaseAppBar(
              appBar: AppBar(),
            )
          : null,
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
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isChosen = 0;
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
                                      color: isChosen == 0
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
                                                  'My info',
                                                  style: TextStyle(
                                                      color: isChosen == 0
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 0
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
                                                  'My info',
                                                  style: TextStyle(
                                                      color: isChosen == 0
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 0
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
                                    isChosen = 1;
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
                                      color: isChosen == 1
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
                                                    Icons
                                                        .local_post_office_outlined,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  'Posts',
                                                  style: TextStyle(
                                                      color: isChosen == 1
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 1
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
                                                  'Posts',
                                                  style: TextStyle(
                                                      color: isChosen == 1
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 1
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
                                    isChosen = 2;
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
                                      color: isChosen == 2
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
                                                  'Favourite',
                                                  style: TextStyle(
                                                      color: isChosen == 2
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 2
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
                                                  child: Icon(Icons.favorite,
                                                      color: Colors.red),
                                                ),
                                                Text(
                                                  'Favourite',
                                                  style: TextStyle(
                                                      color: isChosen == 2
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontSize: isChosen == 2
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
