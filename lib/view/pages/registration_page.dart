import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool isVisible = false;
  bool isLoading = false;

  List<UserModel> userData = <UserModel>[];

  String accountType = 'Community';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _showBasicsFlash({
    flashStyle = FlashBehavior.floating,
    String? message,
  }) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Flash(
            controller: controller,
            behavior: flashStyle,
            position: FlashPosition.bottom,
            boxShadows: kElevationToShadow[1],
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.grey[50],
            margin: const EdgeInsets.symmetric(horizontal: 300),
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              content: Center(child: Text(message!)),
            ),
          ),
        );
      },
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
              'LifeGuard',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('About us'),
          ),
          TextButton(
            onPressed: () {},
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
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.greenAccent,
      body: Stack(
        children: [
          const Image(
            image: NetworkImage(
                'https://cdn.24.co.za/files/Cms/General/d/10548/c1d375b5b2e24464bc2629a265ce3497.jpg'),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Opacity(
            opacity: 0.7,
            child: Container(
              margin: const EdgeInsets.only(top: 60, left: 60),
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60, left: 60),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          label: const Text(
                            'User name',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: 'sarah_thomas01',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.grey[300],
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[300],
                          ),
                          iconColor: Colors.white,
                          label: const Text(
                            'Email address',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: isVisible ? false : true,
                        decoration: InputDecoration(
                          label: const Text(
                            'Password',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: isVisible ? false : true,
                        decoration: InputDecoration(
                          label: const Text(
                            'Confirm password',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.all(16.0),
                    //   child: Center(
                    //     child: Text(
                    //       'Account type',
                    //       style: TextStyle(color: Colors.white, fontSize: 18),
                    //     ),
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Community',
                    //             style: TextStyle(
                    //                 fontSize: 12.0, color: Colors.grey[400]),
                    //           ),
                    //           Radio(
                    //             value: 1,
                    //             groupValue: accountType,
                    //             onChanged: (val) {
                    //               setState(() {
                    //                 accountType = val;
                    //                 account = 'Community';
                    //               });
                    //             },
                    //           ),
                    //           // more widgets ...
                    //         ]),
                    //     Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Clinical Staff',
                    //             style: TextStyle(
                    //                 fontSize: 12.0, color: Colors.grey[400]),
                    //           ),
                    //           Radio(
                    //             value: 2,
                    //             groupValue: accountType,
                    //             onChanged: (val) {
                    //               setState(() {
                    //                 accountType = val;
                    //                 account = 'Clinical staff';
                    //               });
                    //             },
                    //           ),
                    //           // more widgets ...
                    //         ]),
                    //   ],
                    // ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });

                            if (_nameController.text != '' &&
                                _confirmPasswordController.text != '' &&
                                _emailController.text != '' &&
                                _passwordController.text != '') {
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                setState(() {
                                  isLoading = false;
                                });
                                _showBasicsFlash(
                                    message:
                                        'Password mismatch. please Try again.');
                              } else {
                                AuthServices(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ).register().then((value) {
                                  Future.delayed(const Duration(seconds: 3));
                                  FirebaseAuth _auth = FirebaseAuth.instance;
                                  if (_auth.currentUser != null) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .add({
                                      'name': _nameController.text,
                                      'email': auth.currentUser?.email,
                                      'user_id': auth.currentUser?.uid,
                                      'gender': '',
                                      'region': '',
                                      'phone': '',
                                      'profession': '',
                                      'facility': '',
                                      'id_number': '',
                                      'account_type': accountType,
                                      'avatar_url': '',
                                    });

                                    _showBasicsFlash(
                                        message:
                                            'Account Successfully created. You can now edit your profile information.');

                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePage()),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    _showBasicsFlash(
                                        message:
                                            'Failed to create account. Please try again.');
                                    return;
                                  }
                                });
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              _showBasicsFlash(
                                  message: 'Please fill all the credentials');
                              return;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: isLoading
                                ? Container(
                                    width: 16,
                                    height: 16,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    ),
                                  )
                                : const Text('Register'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: const Text(
                              "Sign in here",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Join us now!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
