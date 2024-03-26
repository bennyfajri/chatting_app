import 'package:chatting_app/models/chat.dart';
import 'package:chatting_app/utils/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider =
    Provider((ref) => ChatProvider(firestore: ref.watch(firestoreProvider)));

final chatStream = StreamProvider.autoDispose((ref) => ref.watch(chatProvider).getChats());

class ChatProvider {
  FirebaseFirestore firestore;

  ChatProvider({required this.firestore});

  Stream<List<ChatModel>> getChats() {
    final documentSnapshot = firestore.collection("messages")
    .orderBy("dateCreated", descending: true)
        .snapshots();
    return documentSnapshot.map((event) {
      final result = event.docs
          .map((snapshot) => ChatModel.fromMap(snapshot.data()))
          .toList();
      return result;
    });
  }

  Future<void> uploadChat(ChatModel chat) async {
    try {
      await firestore.collection("messages").add(chat.toMap());
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }
}
