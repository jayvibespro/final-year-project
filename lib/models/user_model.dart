import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userId;
  String name;
  String idNumber;
  String facility;
  String region;
  String email;
  String avatarUrl;
  String phone;
  String gender;
  String profession;

  UserModel({
    required this.id,
    required this.userId,
    required this.avatarUrl,
    required this.email,
    required this.facility,
    required this.gender,
    required this.idNumber,
    required this.name,
    required this.phone,
    required this.profession,
    required this.region,
  });

  factory UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return UserModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      email: doc.data()!['email'],
      name: doc.data()!['name'],
      avatarUrl: doc.data()!['avatar_url'],
      phone: doc.data()!['phone'],
      gender: doc.data()!['gender'],
      region: doc.data()!['region'],
      facility: doc.data()!['facility'],
      profession: doc.data()!['profession'],
      idNumber: doc.data()!['idNumber'],
    );
  }
}
