import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? sender;
  String? text;
  Timestamp? dateCreated;

  ChatModel({
    this.sender,
    this.text,
    this.dateCreated,
  });

  ChatModel copyWith({
    String? sender,
    String? text,
    Timestamp? dateCreated,
  }) {
    return ChatModel(
        sender: sender ?? this.sender,
        text: text ?? this.text,
        dateCreated: dateCreated ?? this.dateCreated);
  }

  static ChatModel empty() => ChatModel(
        sender: "",
        text: "",
        dateCreated: Timestamp.now(),
      );

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    final String? sender = data['sender'];
    final String? text = data['text'];
    final Timestamp? dateCreated = data['dateCreated'];

    return ChatModel(sender: sender, text: text, dateCreated: dateCreated);
  }

  Map<String, dynamic> toMap() {
    return {
      "text" : text,
      "sender" : sender,
      "dateCreated": Timestamp.now()
    };
  }
}
