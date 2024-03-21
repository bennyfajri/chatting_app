import 'package:chatting_app/utils/auth_provider.dart';
import 'package:chatting_app/utils/chat/chat.dart';
import 'package:chatting_app/utils/chat/chat_provider.dart';
import 'package:chatting_app/widgets/message_bubble.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Logout',
            onPressed: () async {
              final navigator = Navigator.of(context);
              ref.read(userProvider.notifier).signOut();

              navigator.pushReplacementNamed(LoginPage.id);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: chats.when(data: (chatList) => ListView(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                children: chatList.map((chat) {
                  final String messageText = chat.text ?? "";
                  final String messageSender = chat.sender ?? "";

                  return MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMyChat: messageSender == auth.currentUser?.displayName,
                  );
                }).toList(),
              ), error: (error, stackTrace) => Center(
                child: Text("$error $stackTrace"),
              ), loading: () => const Center(
    child: CircularProgressIndicator(),
    )),
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
                  onPressed: () {
                    ref.watch(chatProvider).uploadChat(
                          ChatModel(
                            sender: auth.currentUser?.displayName,
                            text: messageController.text,
                          ),
                        );

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
