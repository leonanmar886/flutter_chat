import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/custom_bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageWidget extends StatelessWidget {
  final dynamic message;
  final bool nextMessageInGroup;
  final types.User user;
  final Widget child;

  const MessageWidget({
    super.key,
    required this.message,
    required this.nextMessageInGroup,
    required this.user,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: CustomBubble(
            color: user.id != message.author.id ? const Color(0xffECECEC) : const Color(0xffcce9fe),
            borderRadius: user.id != message.author.id
            ? const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
            )
            : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
            ),
            child: Bubble(
              color: user.id != message.author.id ? const Color(0xffECECEC) : const Color(0xffcce9fe),
              margin: nextMessageInGroup
                  ? const BubbleEdges.symmetric(horizontal: 6)
                  : null,
              shadowColor: Colors.transparent,
              child: message.type == types.MessageType.text
                  ? Text(message.text)
                  : SingleChildScrollView(
                      child: child,
                    ),
            ),
          ),
        ),
      ]
    );
  }
}