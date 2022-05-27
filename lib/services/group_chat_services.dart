import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatServices {
  String? id;
  String? senderId;
  String? groupAdmin;
  String? groupDescription;
  String? message;
  String? date;
  String? groupImage;
  String? groupName;
  List? members;
  dynamic timeStamp;

  GroupChatServices({
    this.id,
    this.senderId,
    this.groupAdmin,
    this.groupName,
    this.message,
    this.date,
    this.members,
    this.groupDescription,
    this.groupImage,
    this.timeStamp,
  });

  createGroup() async {
    await FirebaseFirestore.instance.collection('group_chat').add({
      'members': members,
      'last_message': '',
      'last_date': '',
      'group_admin': groupAdmin,
      'group_description': groupDescription,
      'group_image': groupImage,
      'group_name': groupName,
      'group_id': '',
    }).then((value) => FirebaseFirestore.instance
        .collection('group_chat')
        .doc(value.id)
        .update({'group_id': value.id}));
  }

  sendMessage() async {
    await FirebaseFirestore.instance.collection('group_chat').doc(id).update({
      'last_message': message,
      'last_date': date,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('group_chat')
          .doc(id)
          .collection('messages')
          .add({
        'message': message,
        'sender_id': senderId,
        'date': date,
        'timestamp': timeStamp,
      });
    });
  }
}
