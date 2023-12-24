import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class ChatProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<ChatModel> chatModels = [];
  List<InboxData> inboxDatas = [];

  List<Message> messages = [];

  List<InboxData> getMessages(String receiverId) {
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
