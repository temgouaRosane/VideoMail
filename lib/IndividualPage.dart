import 'dart:convert';

import 'package:gallery_saver/files.dart';
import 'package:videomail/CameraPage.dart';
import 'package:videomail/CustomUI/OwnMessgaeCrad.dart';
import 'package:videomail/CustomUI/ReplyCard.dart';
import 'package:videomail/Model/ChatModel.dart';
import 'package:videomail/Model/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:videomail/Model/chatMessageModel.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({
    Key? key,
    required this.chatModel,
    required this.sourchat,
    required this.path,
  }) : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;
  final String path;


  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  late Future<List<ChatMessageModel>> chatMessage;
  //IO.Socket socket;
  @override
  void initState() {
    super.initState();
    if (widget.path != "") {
      MessageModel messageModel = MessageModel(
        type: "source",
        time: DateTime.now().toString().substring(10, 16),
        url: widget.path,
      );
      setState(() {
        messages.add(messageModel);
      });
    }

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    chatMessage = getMessage();
    print('-------------------------------------------');
    print('-------------------------------------------');
    print(chatMessage);
    print('-------------------------------------------');
  }

  void sendMessage(String message, int sourceId, int targetId, String url) {
    MessageModel messageModel = MessageModel(
      type: "source",
      time: DateTime.now().toString().substring(10, 16),
      url: url,
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  Future<List<ChatMessageModel>> getMessage() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.106:8083/chat/620083259'));
    if (response.statusCode == 200) {
      
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      print("No error");

      return parsed
          .map<ChatMessageModel>((json) => ChatMessageModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (messages[index].type == "source") {
                          return OwnMessageCard(
                            url: messages[index].url,
                          );
                        } else {
                          return ReplyCard(
                            url: messages[index].url,
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CameraPage(
                                                              chatModel: widget
                                                                  .chatModel,
                                                              sourchat: widget
                                                                  .chatModel)));
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xFF128C7E),
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                    //send message
                                    onPressed: () {
                                      if (sendButton) {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        sendMessage(
                                            "", 650082764, 650083259, "");
                                        //_controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }
}
