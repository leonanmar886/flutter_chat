import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
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
          child: Bubble(
            color: user.id != message.author.id ? const Color(0xffECECEC) : const Color(0xffcce9fe),
            margin: nextMessageInGroup
                ? const BubbleEdges.symmetric(horizontal: 6)
                : null,
            nip: nextMessageInGroup
                ? BubbleNip.no
                : user.id != message.author.id ? BubbleNip.leftBottom : BubbleNip.rightBottom,
            child: message.type == types.MessageType.text
                ? Text(message.text)
                : SingleChildScrollView(
                    child: child,
                  ),
          ),
        ),
      ]
    );
  }
}