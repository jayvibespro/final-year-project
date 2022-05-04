import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String messageId;
  String message;
  String senderName;
  String senderId;
  String date;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.senderName,
    required this.date,
    required this.senderId,
  });

  factory MessageModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return MessageModel(
      messageId: doc.id,
      message: doc.data()!['message'],
      senderId: doc.data()!['sender_id'],
      senderName: doc.data()!['sender_name'],
      date: doc.data()!['date'],
    );
  }
}
