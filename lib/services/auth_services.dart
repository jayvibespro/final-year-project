import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthServices {
  String? id;
  String email;
  String? userId;
  String password;
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
    required this.email,
    this.gender,
    this.avatarUrl,
    required this.password,
  });

  register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseAuth _auth = FirebaseAuth.instance;

      var user = FirebaseFirestore.instance.collection('users').add({
        'name': '',
        'email': _auth.currentUser?.email,
        'user_id': _auth.currentUser?.uid,
        'gender': '',
        'region': '',
        'phone': '',
        'profession': '',
        'facility': '',
        'id_number': '',
        'account_type': accountType,
        'avatar_url': '',
      });
      Get.snackbar("Message", "User account successfully created.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(
            seconds: 4,
          ),
          margin: const EdgeInsets.all(16),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.snackbar("Message", "The password provided is too weak.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.snackbar("Message", "Account already exists.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Erro", "e",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    }
  }

  login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar("Message", "User login successfully.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar("Message", "No user found for that email.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 3),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar("Message", "Wrong password",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.snackbar("Message", "User logout successfully.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar("Message", "No user found for that email.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 3),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar("Message", "Wrong password",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    }
  }

  editUserInfo() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;

      var user = FirebaseFirestore.instance.collection('users').doc(id).update({
        'name': name,
        'email': _auth.currentUser?.email,
        'user_id': _auth.currentUser?.uid,
        'gender': gender,
        'region': region,
        'phone': phone,
        'profession': profession,
        'facility': facility,
        'id_number': idNumber,
        'account_type': accountType,
        'avatar_url': avatarUrl,
      });
      Get.snackbar("Message", "User account successfully created.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(
            seconds: 4,
          ),
          margin: const EdgeInsets.all(16),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.snackbar("Message", "The password provided is too weak.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.snackbar("Message", "Account already exists.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Erro", "e",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    }
  }
}
