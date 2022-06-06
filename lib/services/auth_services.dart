import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  String? id;
  String? email;
  String? userId;
  String? password;
  String? name;
  String? phone;
  String? idNumber;
  String? region;
  String? facility;
  String? profession;
  String? avatarUrl;
  String? accountType;
  String? gender;

  AuthServices({
    this.id,
    this.accountType,
    this.profession,
    this.userId,
    this.region,
    this.phone,
    this.name,
    this.idNumber,
    this.facility,
    this.email,
    this.gender,
    this.avatarUrl,
    this.password,
  });

  register() async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  editUserInfo() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;

      var user = FirebaseFirestore.instance.collection('users').doc(id).update({
        'name': name,
        'email': email,
        'user_id': _auth.currentUser?.uid,
        'gender': gender,
        'region': region,
        'phone': phone,
        'profession': profession,
        'facility': facility,
        'id_number': idNumber,
        'avatar_url': avatarUrl,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
