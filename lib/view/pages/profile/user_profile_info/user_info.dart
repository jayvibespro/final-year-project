import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/view/pages/profile/user_profile_info/edit_profile_page.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
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
    const _tabletScreenWidth = 768;
    const _laptopScreenWidth = 1024;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Container(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
                      padding: _screenWidth <= _tabletScreenWidth
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
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
    );
  }
}
