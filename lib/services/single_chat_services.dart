import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatServices {
  String? id;
  String? senderId;
  String? message;
  String? date;
  String? receiverId;
  String? receiverName;
  String? receiverImage;
  String? receiverEmail;
  List? members;
  List? searchIndex;
  dynamic timeStamp;

  SingleChatServices({
    this.searchIndex,
    this.id,
    this.senderId,
    this.message,
    this.date,
    this.members,
    this.receiverEmail,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
    this.timeStamp,
  });

  createChat() async {
    await FirebaseFirestore.instance.collection('single_chat').add({
      'members': members,
      'last_message': message,
      'last_date': date,
      'receiver_id':receiverId,
      'receiver_email': receiverEmail,
      'receiver_image': receiverImage,
      'receiver_name': receiverName,
      'search_index': searchIndex,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('single_chat')
          .doc(value.id)
          .collection('messages')
          .add({
        'message': message,
        'sender_id': senderId,
        'date': date,
        'timestamp': timeStamp,
      });
    });
  }

  sendMessage() async {
    await FirebaseFirestore.instance.collection('single_chat').doc(id).update({
      'last_message': message,
      'last_date': date,
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
        'timestamp': timeStamp,
      });
    });
  }
}
