import 'package:chatting_app/models/chat.dart';
import 'package:chatting_app/pages/schedule_page.dart';
import 'package:chatting_app/provider/chat_provider.dart';
import 'package:chatting_app/utils/auth_provider.dart';
import 'package:chatting_app/utils/constant.dart';
import 'package:chatting_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_page.dart';

class ChatPage extends HookConsumerWidget {
  static const String id = 'chat_page';

  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(userProvider);
    final chats = ref.watch(chatStream);
    final messageController = useTextEditingController();
    final editMode = useState(false);
    final messageId = useState("");
    ValueNotifier<Timestamp> messageDate = useState(Timestamp.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm),
            tooltip: 'Alarm',
            onPressed: () async {
              Constant.goToPage(context, const SchedulePage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final navigator = Navigator.of(context);
              ref.read(userProvider.notifier).signOut();

              navigator.pushReplacementNamed(LoginPage.id);
            },
          ),
          if (editMode.value)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
              onPressed: () async {
                editMode.value = false;
                messageId.value = "";
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: chats.when(
                data: (chatList) => ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      final chat = chatList[index];
                      final String messageText = chat.text ?? "";
                      final String messageSenderId = chat.senderId ?? "";
                      final String messageSender = chat.sender ?? "";
                      final isSameWithBefore = index != chatList.length - 1
                          ? messageSenderId == chatList[index + 1].senderId
                          : false;

                      return MessageBubble(
                        sender: messageSender,
                        text: messageText,
                        isMyChat: messageSenderId == auth.currentUser?.uid,
                        isSameWithBefore: isSameWithBefore,
                        onLongPress: () {
                          messageController.text = messageText;
                          messageId.value = chat.id ?? "";
                          messageDate.value =
                              chat.dateCreated ?? Timestamp.now();
                          editMode.value = true;
                        },
                      );
                    }),
                error: (error, stackTrace) => Center(
                  child: Text("$error $stackTrace"),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () async {
                    if (editMode.value) {
                      await ref.watch(chatProvider).updateChat(
                          ChatModel(
                              senderId: auth.currentUser?.uid,
                              sender: auth.currentUser?.displayName,
                              text: messageController.text,
                              dateCreated: messageDate.value),
                          messageId.value);
                    } else {
                      await ref.watch(chatProvider).uploadChat(
                            ChatModel(
                              senderId: auth.currentUser?.uid,
                              sender: auth.currentUser?.displayName,
                              text: messageController.text,
                            ),
                          );
                    }

                    editMode.value = false;
                    messageId.value = "";
                    messageDate.value = Timestamp.now();
                    messageController.clear();
                  },
                  child: const Text('SEND'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
