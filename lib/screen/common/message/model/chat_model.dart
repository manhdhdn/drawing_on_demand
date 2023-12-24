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

  InboxData({this.id, this.message});
}

enum MessageType { text, image }

class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentTime,
    required this.messageType,
  });

  Message.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        receiverId = json['receiverId'],
        content = json['content'],
        sentTime = DateTime.parse(json['sentTime']),
        messageType = MessageType.values.firstWhere(
          (e) => e.toString() == json['messageType'],
        );

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sentTime': sentTime,
      'messageType': messageType.toString(),
    };
  }
}
