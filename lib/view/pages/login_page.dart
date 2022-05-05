import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/view/pages/posts/posts_page.dart';
import 'package:finalyearproject/view/pages/registration_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHover = false;
  bool isVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              margin: const EdgeInsets.only(top: 100, left: 60),
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 100, left: 60),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        // border: InputBorder.none,
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
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          AuthServices(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .login();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PostsPage(title: 'Save the Future')),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Sign in'),
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
                          'Do not have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
                            );
                          },
                          child: const Text(
                            "Register Now",
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
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
