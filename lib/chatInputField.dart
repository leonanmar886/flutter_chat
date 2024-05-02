import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatInputField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final void Function(types.PartialText) handleSendPressed;

  ChatInputField({
    super.key,
    required this.handleSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Especifique o padding aqui
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min, // Adicione esta linha
                  children: [
                    IconButton(
                      icon: const Icon(
                          Icons.file_present_outlined, 
                          color: Colors.blueAccent
                        ),
                      onPressed: () {
                        // Handle add icon press
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blueAccent,
                        ),
                      onPressed: () {
                        // Handle add icon press
                      },
                    ),
                  ],
                ),
              ),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
          IconButton(
            icon: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.blueAccent,
                size: 40.0,
              ),
            onPressed: () {
              final partialText = types.PartialText(text: _controller.text);
              handleSendPressed(partialText);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
