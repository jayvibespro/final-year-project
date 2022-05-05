import 'package:finalyearproject/services/post_service.dart';
import 'package:finalyearproject/view/pages/home_chat_page.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/widgets/post_container.dart';
import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool isHover = false;

  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.black),
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
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          "Recent Posts",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    PostContainer(),
                    PostContainer(),
                    PostContainer(),
                    PostContainer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: () {
                    addAdvanceBottomSheets(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Create new post'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addAdvanceBottomSheets(context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Create your post.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: TextField(
                          controller: _postController,
                          minLines: 5,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText: 'Write here...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 0.5),
                              blurRadius: 5.0,
                              offset: Offset(2, 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          PostService(
                                  post: _postController.text,
                                  date: '12/07/2022',
                                  likes: '0')
                              .addPost();

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Add Post'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }
}
