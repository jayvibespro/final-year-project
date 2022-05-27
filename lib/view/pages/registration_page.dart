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

  bool isHover = false;
  bool isVisible = false;
  bool isLoading = false;

  List<UserModel> userData = <UserModel>[];

  Object? accountType = 1;

  String account = 'Community';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            child: InkWell(
              onTap: () {},
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: Text(
                        'User name',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'User name',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: Text(
                        'Email',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: Text(
                        'Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: isVisible ? false : true,
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Account type',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Community',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[400]),
                              ),
                              Radio(
                                value: 1,
                                groupValue: accountType,
                                onChanged: (val) {
                                  setState(() {
                                    accountType = val;
                                    account = 'Community';
                                  });
                                },
                              ),
                              // more widgets ...
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Clinical Staff',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[400]),
                              ),
                              Radio(
                                value: 2,
                                groupValue: accountType,
                                onChanged: (val) {
                                  setState(() {
                                    accountType = val;
                                    account = 'Clinical staff';
                                  });
                                },
                              ),
                              // more widgets ...
                            ]),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
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
                                    .where('user_id',
                                        isEqualTo: auth.currentUser?.uid)
                                    .get()
                                    .then((element) {
                                  for (final DocumentSnapshot<
                                          Map<String, dynamic>> doc
                                      in element.docs) {
                                    userData.add(UserModel.fromDocumentSnapshot(
                                        doc: doc));
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
                                  message:
                                      'Error creating account. Please try again.');
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

class MobileRegisterPage extends StatefulWidget {
  const MobileRegisterPage({Key? key}) : super(key: key);

  @override
  State<MobileRegisterPage> createState() => _MobileRegisterPageState();
}

class _MobileRegisterPageState extends State<MobileRegisterPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool isVisible = false;
  bool isLoading = false;

  List<UserModel> userData = <UserModel>[];

  Object? accountType = 1;

  String account = 'Community';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
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
            child: const Text('More'),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16, 8, 0),
                    child: Text(
                      'User name',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'User name',
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16, 8, 0),
                    child: Text(
                      'Email',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        focusColor: Colors.black54,
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.black54,
                        ),
                        iconColor: Colors.white,
                        hintText: 'abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16, 8, 0),
                    child: Text(
                      'Password',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: TextField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.black),
                      obscureText: isVisible ? false : true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Account type',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Community',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                            Radio(
                              value: 1,
                              groupValue: accountType,
                              onChanged: (val) {
                                setState(() {
                                  accountType = val;
                                  account = 'Community';
                                });
                              },
                            ),
                            // more widgets ...
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Clinical Staff',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                            Radio(
                              value: 2,
                              groupValue: accountType,
                              onChanged: (val) {
                                setState(() {
                                  accountType = val;
                                  account = 'Clinical staff';
                                });
                              },
                            ),
                            // more widgets ...
                          ]),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
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
                                  .where('user_id',
                                      isEqualTo: auth.currentUser?.uid)
                                  .get()
                                  .then((element) {
                                for (final DocumentSnapshot<
                                    Map<String, dynamic>> doc in element.docs) {
                                  userData.add(
                                      UserModel.fromDocumentSnapshot(doc: doc));
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
                                message:
                                    'Error creating account. Please try again.');
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileLoginPage()),
                            );
                          },
                          child: const Text(
                            "Sign in here",
                            style: TextStyle(color: Colors.blue),
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
      ),
    );
  }
}
