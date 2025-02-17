import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? senderId;
  String? sender;
  String? text;
  Timestamp? dateCreated;

  ChatModel({
    this.id,
    this.senderId,
    this.sender,
    this.text,
    this.dateCreated,
  });

  ChatModel copyWith({
    String? senderId,
    String? sender,
    String? text,
    String? test,
    Timestamp? dateCreated,
  }) {
    return ChatModel(
        sender: sender ?? this.sender,
        text: text ?? this.text,
        dateCreated: dateCreated ?? this.dateCreated);
  }

  static ChatModel empty() => ChatModel(
        id: "",
        senderId: "",
        sender: "",
        text: "",
        dateCreated: Timestamp.now(),
      );

  factory ChatModel.fromMap(Map<String, dynamic> data, String docId) {
    final String? senderId = data['senderId'];
    final String? sender = data['sender'];
    final String? text = data['text'];
    final Timestamp? dateCreated = data['dateCreated'];

    return ChatModel(
        id: docId,
        senderId: senderId,
        sender: sender,
        text: text,
        dateCreated: dateCreated);
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "sender": sender,
      "senderId": senderId,
      "dateCreated": dateCreated ?? Timestamp.now(),
    };
  }
}
