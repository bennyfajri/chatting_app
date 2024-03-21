import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMyChat;
  final bool isSameWithBefore;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMyChat,
    required this.isSameWithBefore,
  }) : super(key: key);

  final senderBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  );

  final otherBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );

  final sameAsBeforeBorderRadius = const BorderRadius.all(Radius.circular(16));

  final sameAsBeforePadding = const EdgeInsets.symmetric(horizontal: 8);

  final diffrentThanBeforePadding = const EdgeInsets.symmetric(horizontal: 8 , vertical: 4);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isSameWithBefore ? sameAsBeforePadding : diffrentThanBeforePadding,
      child: Column(
        crossAxisAlignment:
            isMyChat ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if(!isSameWithBefore) Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: isMyChat ? Colors.lightBlue : Colors.white,
            borderRadius: isSameWithBefore
                ? sameAsBeforeBorderRadius
                : isMyChat
                    ? senderBorderRadius
                    : otherBorderRadius,
            elevation: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMyChat ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
