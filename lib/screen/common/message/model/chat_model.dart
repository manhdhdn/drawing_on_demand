import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatModel {
  String? title;
  String? subTitle;
  String? image;
  IconData? icon;
  bool? isCheckList;
  Color? color;

  ChatModel(
      {this.title,
      this.subTitle,
      this.image,
      this.color,
      this.isCheckList = false,
      this.icon});
}

class InboxData {
  int? id;
  String? message;
  DateTime? sentTime;

  InboxData({this.id, this.message, this.sentTime});
}

enum MessageType { text, image }

class Message {
  String? senderId;
  String? receiverId;
  String? content;
  DateTime? sentTime;
  MessageType? messageType;

  Message({
    this.senderId,
    this.receiverId,
    this.content,
    this.sentTime,
    this.messageType,
  });

  Message.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        receiverId = json['receiverId'],
        content = json['content'],
        sentTime = json['sentTime'].toDate(),
        messageType = MessageType.values.firstWhere(
          (type) => type.toString() == json['messageType'],
        );

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sentTime': Timestamp.fromDate(sentTime!),
      'messageType': messageType.toString(),
    };
  }
}
