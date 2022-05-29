import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              "Welcome",
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
                      controller: _emailController,
                      decoration: const InputDecoration(
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
                      controller: _passwordController,
                      decoration: const InputDecoration(
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
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (_emailController.text != '' &&
                      _passwordController.text != '') {
                    AuthServices(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .login();
                  } else {
                    _showBasicsFlash(
                      duration: const Duration(seconds: 3),
                      message:
                          'Make sure you fill all the credentials and try again.',
                    );
                    setState(() {
                      isLoading = false;
                    });
                  }
                  await Future.delayed(const Duration(seconds: 2));

                  if (auth.currentUser != null) {
                    setState(() {
                      isLoading = false;
                    });
                    _showBasicsFlash(
                      duration: const Duration(seconds: 3),
                      message: 'Welcome back!',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatRoomPage()),
                    );

                    _showBasicsFlash(
                      duration: const Duration(seconds: 3),
                      message: 'Welcome back!',
                    );
                  } else {
                    return;
                  }
                },
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white.withOpacity(0.5),
                            )
                          : Text(
                              'Sign in',
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
                          builder: (context) => const SignUpScreen()));
                },
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        'Sign up',
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
