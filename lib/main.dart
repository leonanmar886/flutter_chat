import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatInputField.dart';
import 'package:flutter_chat/chatTheme.dart';
import 'package:flutter_chat/message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18.0,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  children: [
                    Text(
                      'Rota 2554223',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0),
                    Icon(Icons.circle, color: Color(0xFF909090), size: 10.0),
                    SizedBox(width: 5.0),
                    Text(
                      'Pedido #2515223',
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                    )
                  ]
                ),
              Text(
                'Nome abaixo',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        body:Container(
          color: const Color(0xFFF7F7F7),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 15.0),
                width: 325,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Color(0xFF6B6B6B), fontStyle: FontStyle.italic),
                    children: <TextSpan>[
                      TextSpan(text: 'Aberturas de chamados podem levar '),
                      TextSpan(
                        text: 'até 24h',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF464646),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' para serem respondidos'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Chat(
                  messages: _messages,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                  bubbleBuilder: _bubbleBuilder,
                  customDateHeaderText: customDateHeaderText,
                  emptyState: Container(),
                  customBottomWidget: ChatInputField(
                    handleSendPressed: _handleSendPressed,
                    handleFileSelection: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      _handleFileSelection();
                    },
                    handleCameraSelection: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      _handleImageSelection();
                    },
                  ),
                  theme: const MyChatTheme()
                ),
              ),
            ],
          ),
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _handleFileSelection() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  if (result != null && result.files.single.path != null && mounted) {
    final message = types.FileMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      name: result.files.single.name,
      size: result.files.single.size,
      uri: result.files.single.path!,
    );

    _addMessage(message);
  }
}

void _handleImageSelection() async {
  final result = await ImagePicker().pickImage(
    imageQuality: 70,
    maxWidth: 1440,
    source: ImageSource.gallery,
  );

  if (result != null && mounted) {
    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final message = types.ImageMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      height: image.height.toDouble(),
      id: randomString(),
      name: result.name,
      size: bytes.length,
      uri: result.path,
      width: image.width.toDouble(),
    );

    _addMessage(message);
  }
}

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }


  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MessageWidget(
          message: message,
          nextMessageInGroup: nextMessageInGroup,
          user: _user,
          child: child,
        ),
      ],
    );
}

String customDateHeaderText(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final messageDate = DateTime(date.year, date.month, date.day);

  if (messageDate == today) {
    return 'Hoje';
  } else if (messageDate == yesterday) {
    return 'Ontem';
  } else if (now.difference(messageDate).inDays < 365) {
    return '${messageDate.day} de ${monthParserText(messageDate.month)}';
  } else {
    return '${messageDate.day} de ${monthParserText(messageDate.month)} de ${messageDate.year}';}
}

String monthParserText(int month) {
  switch (month) {
    case 1:
      return 'janeiro';
    case 2:
      return 'fevereiro';
    case 3:
      return 'março';
    case 4:
      return 'abril';
    case 5:
      return 'maio';
    case 6:
      return 'junho';
    case 7:
      return 'julho';
    case 8:
      return 'agosto';
    case 9:
      return 'setembro';
    case 10:
      return 'outubro';
    case 11:
      return 'novembro';
    case 12:
      return 'dezembro';
    default:
      return '';
  }
}

