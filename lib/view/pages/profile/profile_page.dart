import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/profile/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isHover = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

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

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Profile Picture')),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Divider(),
            Expanded(
              child: SizedBox(),
            ),
            FlutterLogo(
              size: 200,
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.download,
            color: Colors.green,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Close'),
          ),
        ),
      ],
    );
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
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    UserModel userSnapshot = snapshot.data![index];
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 70,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: InkWell(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[50],
                                    radius: 26,
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                bottom: 0,
                                right: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            '${userSnapshot.name}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 16, left: 64, right: 64, bottom: 8),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Phone'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.phone}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Email'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.email}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ID number'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.idNumber}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Gender'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.gender}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Profession'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.profession}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Working facility'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.facility}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Region'),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('${userSnapshot.region}')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, left: 64, right: 64),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                          userData: userSnapshot,
                                        )));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Edit profile info'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ]);
                  },
                );
              } else {
                return const Center(
                  child: Text('An Error Occurred...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
