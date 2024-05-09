import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatInputField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final void Function(types.PartialText) handleSendPressed;
  final void Function() handleFileSelection;
  final void Function() handleCameraSelection;

  ChatInputField({
    super.key,
    required this.handleSendPressed,
    required this.handleFileSelection,
    required this.handleCameraSelection,
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    color: Colors.black45,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min, // Adicione esta linha
                  children: [
                    IconButton(
                      icon: const Icon(
                          Icons.file_present_outlined, 
                          color: Color(0xFF0291FB)
                        ),
                      onPressed: () {
                        handleFileSelection();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF0291FB),
                        ),
                      onPressed: () {
                        handleCameraSelection();
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
                IconData(0xe800, fontFamily: 'MyFlutterApp'),
                color: Color(0xFF0291FB),
                size: 25.0,
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
