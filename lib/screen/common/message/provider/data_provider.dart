import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/pref_utils.dart';
import '../model/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<InboxData> inboxDatas = [];

  UserModel user = UserModel();
  List<UserModel> users = [];
  List<Message> messages = [];

  UserModel getUser(dynamic uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = UserModel.fromJson(user.data()!);

      notifyListeners();
    });

    return user;
  }

  List<UserModel> getChatedUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(jsonDecode(PrefUtils().getAccount())['Id'])
        .collection('chats')
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users =
          users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

      notifyListeners();
    });

    return users;
  }

  List<InboxData> getMessages(dynamic receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(jsonDecode(PrefUtils().getAccount())['Id'])
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();

      inboxDatas.clear();
      for (var message in this.messages) {
        inboxDatas.add(
          InboxData(
            id: message.senderId == jsonDecode(PrefUtils().getAccount())['Id']
                ? 0
                : 1,
            message: message.content,
            sentTime: message.sentTime,
          ),
        );
      }

      notifyListeners();
      scrollDown();
    });

    return inboxDatas;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        },
      );
}
