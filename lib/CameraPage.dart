import 'package:videomail/CameraScreen.dart';
import 'package:flutter/material.dart';
import 'package:videomail/Model/ChatModel.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);

  final ChatModel chatModel;
  final ChatModel sourchat;
  @override
  Widget build(BuildContext context) {
    return CameraScreen(
      chatModel: chatModel,
      sourchat: sourchat,
    );
  }
}
