import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatConversationModel {
  String id;
  String groupName;
  String groupDescription;
  String groupImage;
  String lastMessage;
  String lastDate;
  List members;
  String groupId;

  GroupChatConversationModel({
    required this.members,
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.lastMessage,
    required this.lastDate,
    required this.id,
    required this.groupImage,
  });

  factory GroupChatConversationModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return GroupChatConversationModel(
      id: doc.id,
      lastMessage: doc.data()!['last_message'],
      groupId: doc.data()!['group_id'],
      groupImage: doc.data()!['group_image'],
      groupDescription: doc.data()!['group_description'],
      groupName: doc.data()!['group_name'],
      lastDate: doc.data()!['last_date'],
      members: doc.data()!['members'],
    );
  }
}

class GroupChatMessagesModel {
  String id;
  String senderId;
  String message;
  String date;
  dynamic timestamp;

  GroupChatMessagesModel({
    required this.senderId,
    required this.message,
    required this.date,
    required this.id,
    required this.timestamp,
  });

  factory GroupChatMessagesModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return GroupChatMessagesModel(
      id: doc.id,
      message: doc.data()!['message'],
      senderId: doc.data()!['sender_id'],
      date: doc.data()!['date'],
      timestamp: doc.data()!['timestamp'],
    );
  }
}
