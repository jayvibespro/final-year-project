import 'package:finalyearproject/view/pages/chat_room.dart';
import 'package:finalyearproject/view/pages/login_page.dart';
import 'package:finalyearproject/view/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBA4PeG_wx91FJzVqgRe8zeApYgYzfgn3c",
          authDomain: "final-year-project-4ee02.firebaseapp.com",
          projectId: "final-year-project-4ee02",
          storageBucket: "final-year-project-4ee02.appspot.com",
          messagingSenderId: "359367705624",
          appId: "1:359367705624:web:bc0e1dccbae46386036f6d",
          measurementId: "G-4V1ZJSJYQ7"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black, backgroundColor: Colors.white),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _tabletScreenWidth = 768;
    final _screenSizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatRoomPage();
          } else {
            return _screenSizeWidth <= _tabletScreenWidth
                ? const SignInScreen()
                : LoginPage();
          }
        },
      ),
    );
  }
}
