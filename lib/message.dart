import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final dynamic message;
  final bool nextMessageInGroup;
  final types.User user;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.nextMessageInGroup,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: user.id != message.author.id
          ? [
              Bubble(
                color: message.type == types.MessageType.image
                    ? const Color(0xfff5f5f7)
                    : const Color(0xffcce9fe),
                margin: nextMessageInGroup
                    ? const BubbleEdges.symmetric(horizontal: 6)
                    : null,
                nip: nextMessageInGroup
                    ? BubbleNip.no
                    : BubbleNip.leftBottom,
                child: Text(message.text),
              ),
              Text(
                DateFormat('HH:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!)),
                style: const TextStyle(color: Colors.grey),
              ),
            ]
          : [
              Text(
                DateFormat('HH:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!)),
                style: const TextStyle(color: Colors.grey) ,
              ),
              Bubble(
                color: message.type == types.MessageType.image
                    ? const Color(0xfff5f5f7)
                    : const Color(0xffcce9fe),
                margin: nextMessageInGroup
                    ? const BubbleEdges.symmetric(horizontal: 6)
                    : null,
                nip: nextMessageInGroup
                    ? BubbleNip.no
                    : BubbleNip.rightBottom,
                child: Text(message.text),
              ),
            ],
    );
  }
}