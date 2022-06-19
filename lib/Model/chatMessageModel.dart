import 'package:flutter/services.dart';

class ChatMessageModel {
  String send_number;
  String receive_number;
  bool isGroup;
  String time;
  String sender;
  String receiver;
  bool select = false;
  //ByteData video;
  int id;
  ChatMessageModel({
    this.send_number = "",
    this.receive_number = "",
    this.isGroup = false,
    this.time = "",
    this.sender = "",
    this.receiver = "",
    this.select = false,
    this.id = 0,
    //this.video="",
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> json) {
    return ChatMessageModel(
      send_number: json['send_number'],
      receive_number: json['receive_number'],
      sender: json['sender'],
      receiver: json['receiver'],
      time: json['send_date'],
      //receiver: json['lastStatusTime'],
    );
  }
}
