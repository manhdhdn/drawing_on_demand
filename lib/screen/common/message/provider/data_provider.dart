import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/pref_utils.dart';
import '../model/chat_model.dart';

List<ChatModel> maanGetChatList() {
  List<ChatModel> list = [];
  list.add(ChatModel(
      title: 'Prince Mahmud',
      subTitle: 'hello',
      image:
          "https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg"));
  return list;
}

List<InboxData> maanInboxChatDataList() {
  List<InboxData> list = [];
  list.add(InboxData(id: 0, message: 'yeah,,'));
  list.add(InboxData(
      id: 1,
      message:
          'aa? I am home waiting for you waiting for youwaiting for you waiting for youwaiting for you waiting for you'));
  list.add(
      InboxData(id: 1, message: 'sorry but i can\'t find your home number'));
  list.add(InboxData(id: 0, message: 'Please knock on dor'));
  list.add(InboxData(
      id: 0,
      message:
          'I am home waiting for you waiting for youwaiting for you waiting for youwaiting for you waiting for you'));
  list.add(InboxData(id: 0, message: 'Hi Miranda'));
  list.add(InboxData(id: 1, message: 'I am on my way to your home visit'));
  return list;
}

class ChatProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<ChatModel> chatModels = [];
  List<InboxData> inboxDatas = [];

  List<Message> messages = [];

  List<InboxData> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();

      scrollDown();
    });

    for (var message in messages) {
      inboxDatas.add(InboxData(
          id: message.senderId == jsonDecode(PrefUtils().getAccount())['Id']
              ? 0
              : 1,
          message: message.content));
    }

    notifyListeners();

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
