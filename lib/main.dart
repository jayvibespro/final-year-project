import 'package:finalyearproject/view/pages/login_page.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save the future',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
