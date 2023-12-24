import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_on_demand/screen/common/message/model/chat_model.dart';

class ChatFunction {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
    required String senderId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: senderId,
    );

    await addMessageToChat(message, receiverId, senderId);
  }

  static Future<void> addMessageToChat(
    Message message,
    String receiverId,
    String senderId,
  ) async {
    await _firestore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add(message.toJson());
  }
}
