import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDescriptionModel {
  String id;
  String groupName;
  String groupDescription;
  String groupImage;
  String groupAdmin;
  // String lastDate;
  List members;

  GroupDescriptionModel({
    required this.members,
    required this.groupName,
    required this.groupDescription,
    required this.groupAdmin,
    // required this.lastDate,
    required this.id,
    required this.groupImage,
  });

  factory GroupDescriptionModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return GroupDescriptionModel(
      id: doc.id,
      groupAdmin: doc.data()!['group_admin'],
      groupImage: doc.data()!['group_image'],
      groupDescription: doc.data()!['group_description'],
      groupName: doc.data()!['group_name'],
      // lastDate: doc.data()!['last_date'],
      members: doc.data()!['members'],
    );
  }
}
