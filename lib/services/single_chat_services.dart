import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SingleChatServices {
  String? id;
  String? senderId;
  String? message;
  String? date = DateFormat('MMM d, kk:mm').format(DateTime.now()).toString();
  String? receiverId;
  String? receiverName;
  String? receiverImage;
  String? receiverEmail;
  String? senderName;
  String? senderEmail;
  String? senderImage;
  List? members;

  SingleChatServices({
    this.id,
    this.senderId,
    this.senderEmail,
    this.senderName,
    this.senderImage,
    this.message,
    this.members,
    this.receiverEmail,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
  });

  createChat() async {
    await FirebaseFirestore.instance.collection('single_chat').add({
      'members': members,
      'last_message': message,
      'last_date': date,
      'sender_id': senderId,
      'sender_email': senderEmail,
      'sender_name': senderName,
      'sender_image': senderImage,
      'receiver_id': receiverId,
      'receiver_email': receiverEmail,
      'receiver_image': receiverImage,
      'receiver_name': receiverName,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('single_chat')
          .doc(value.id)
          .collection('messages')
          .add({
        'message': message,
        'sender_id': senderId,
        'date': date,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  sendMessage() async {
    await FirebaseFirestore.instance.collection('single_chat').doc(id).update({
      'last_message': message,
      'last_date': date,
      'sender_id': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'receiver_email': receiverEmail,
      'receiver_image': receiverImage,
      'receiver_name': receiverName,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('single_chat')
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
