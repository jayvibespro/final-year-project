import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatConversationModel {
  String id;
  String receiverName;
  String receiverEmail;
  String receiverImage;
  String receiverId;
  String lastMessage;
  String lastDate;
  List members;

  SingleChatConversationModel({
    required this.members,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverId,
        required this.lastMessage,
    required this.lastDate,
    required this.id,
    required this.receiverImage,
  });

  factory SingleChatConversationModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SingleChatConversationModel(
      id: doc.id,
      lastMessage: doc.data()!['last_message'],
      receiverImage: doc.data()!['receiver_image'],
      receiverEmail: doc.data()!['receiver_email'],
      receiverName: doc.data()!['receiver_name'],
      receiverId: doc.data()!['receiver_id'],
      lastDate: doc.data()!['last_date'],
      members: doc.data()!['members'],
    );
  }
}

class SingleChatMessagesModel {
  String id;
  String senderId;
  String message;
  String date;
  dynamic timestamp;

  SingleChatMessagesModel({
    required this.senderId,
    required this.message,
    required this.date,
    required this.id,
    required this.timestamp,
  });

  factory SingleChatMessagesModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SingleChatMessagesModel(
      id: doc.id,
      message: doc.data()!['message'],
      senderId: doc.data()!['sender_id'],
      date: doc.data()!['date'],
      timestamp: doc.data()!['timestamp'],
    );
  }
}
