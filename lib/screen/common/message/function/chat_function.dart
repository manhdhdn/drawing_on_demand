import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_on_demand/core/utils/pref_utils.dart';
import 'package:drawing_on_demand/screen/common/message/model/chat_model.dart';

class ChatFunction {
  // Create user
  static Future<void> createUser({
    required String name,
    required String image,
  }) async {
    dynamic uid = jsonDecode(PrefUtils().getAccount())['Id'];

    final user = UserModel(
      uid: uid,
      name: name,
      image: image,
      lastMessage: '',
      isSeen: false,
      lastActive: DateTime.now(),
      isOnline: true,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toJson());
  }

  // Update user
  static Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(jsonDecode(PrefUtils().getAccount())['Id'])
          .update(data);
    } catch (error) {
      createUser(
        name: jsonDecode(PrefUtils().getAccount())['Name'],
        image: jsonDecode(PrefUtils().getAccount())['Avatar'],
      );
    }
  }

  static Future<void> createChat({
    required dynamic senderId,
    required dynamic receiverId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .set(
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .get()
              .then((value) => value.data()!),
        );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .update({
      'lastMessage': 'artist you want to chat with',
      'isSeen': false,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .set(
          await FirebaseFirestore.instance
              .collection('users')
              .doc(senderId)
              .get()
              .then((value) => value.data()!),
        );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .update({
      'lastMessage': 'want to chat with you',
      'isSeen': false,
    });
  }

  static Future<void> updateChatUser({
    required dynamic senderId,
    required dynamic receiverId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .set(
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .get()
              .then((value) => value.data()!),
        );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .set(
          await FirebaseFirestore.instance
              .collection('users')
              .doc(senderId)
              .get()
              .then((value) => value.data()!),
        );
  }

  static Future<void> addTextMessage({
    required String content,
    required dynamic senderId,
    required dynamic receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: senderId,
    );

    await addMessageToChat(message, senderId, receiverId);
  }

  static Future<void> addMessageToChat(
    Message message,
    dynamic senderId,
    dynamic receiverId,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .update({
      'lastMessage': message.content,
      'lastActive': DateTime.now(),
      'isSeen': true,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .update({
      'lastMessage': message.content,
      'lastActive': DateTime.now(),
      'isSeen': false,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add(message.toJson());
  }
}
