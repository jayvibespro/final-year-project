import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupChatServices {
  String? id;
  String? senderId;
  String? groupAdmin;
  String? groupDescription;
  String? message;
  String? date = DateFormat('MMM d, kk:mm').format(DateTime.now()).toString();
  String? groupImage;
  String? groupName;
  List? members;

  GroupChatServices({
    this.id,
    this.senderId,
    this.groupAdmin,
    this.groupName,
    this.message,
    this.members,
    this.groupDescription,
    this.groupImage,
  });

  createGroup() async {
    await FirebaseFirestore.instance.collection('group_chat').add({
      'members': members,
      'last_message': '',
      'last_date': '',
      'timestamp': FieldValue.serverTimestamp(),
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
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('group_chat')
          .doc(id)
          .collection('messages')
          .add({
        'message': message,
        'sender_id': senderId,
        'date': date,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }
}
