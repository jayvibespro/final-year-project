import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/profile/profile_page.dart';
import 'package:finalyearproject/view/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool isVisible = false;
  bool isLoading = false;

  List<UserModel> userData = <UserModel>[];

  Object? accountType = 1;

  String account = 'Community';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _showBasicsFlash({
    Duration? duration,
    flashStyle = FlashBehavior.floating,
    String? message,
  }) {
    showFlash(
      context: context,
      duration: duration,
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
            margin: const EdgeInsets.symmetric(horizontal: 0),
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
    final topPadding = MediaQuery.of(context).size.height * 0.1;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(17, 131, 222, 1),
            Color.fromRGBO(160, 148, 227, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: topPadding,
            ),
            Text(
              'Life Guard',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Hi there!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.4)),
            ),
            Text(
              "Let's get started",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        hintText: "    User name",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_outlined),
                        hintText: "    Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        hintText: "    Password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        hintText: "    Confirm password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    setState(() {
                      isLoading = false;
                    });
                    _showBasicsFlash(
                        duration: const Duration(seconds: 3),
                        message: 'Password mismatch. please Try again.');
                  }

                  if (_nameController.text != '' &&
                      _emailController.text != '' &&
                      _passwordController.text != '') {
                    AuthServices(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      accountType: account,
                    ).register();
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    _showBasicsFlash(
                        duration: const Duration(seconds: 3),
                        message: 'Please fill all the credentials');
                    return;
                  }

                  Future.delayed(const Duration(seconds: 3));

                  if (auth.currentUser != null) {
                    try {
                      _db
                          .collection('users')
                          .where('user_id', isEqualTo: auth.currentUser?.uid)
                          .get()
                          .then((element) {
                        for (final DocumentSnapshot<Map<String, dynamic>> doc
                            in element.docs) {
                          userData
                              .add(UserModel.fromDocumentSnapshot(doc: doc));
                        }
                      });
                    } catch (e) {
                      rethrow;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );

                    _showBasicsFlash(
                        duration: const Duration(seconds: 3),
                        message:
                            'Account Successfully created. You can now edit your profile information.');

                    setState(() {
                      isLoading = false;
                    });

                    print(auth.currentUser?.uid);
                  } else {
                    setState(() {
                      isLoading = false;
                    });

                    _showBasicsFlash(
                        duration: const Duration(seconds: 3),
                        message: 'Error creating account. Please try again.');
                  }
                },
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Or',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                },
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
