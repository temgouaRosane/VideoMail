import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:video_player/video_player.dart';
import 'package:videomail/IndividualPage.dart';
import 'package:videomail/Model/ChatModel.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage(
      {Key? key,
      required this.path,
      required this.chatModel,
      required this.sourchat})
      : super(key: key);
  final String path;
  final ChatModel chatModel;
  final ChatModel sourchat;
  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  _stockeVideo() async {
    await GallerySaver.saveVideo(widget.path);
    //File(widget.filePath).deleteSync();
    _sendMessage();
  }

  _sendMessage() async {
    try {
      //int receive_number = 650082764;
      //int send_number = 650083259;

      print(
          "----------------------------------------------------------------------192.168.199.2");
      print("in send message");
      print(
          "----------------------------------------------------------------------");
      var request =
          MultipartRequest("POST", Uri.parse("http://192.168.199.2:8083/chat"));
      print(
          "----------------------------------------------------------------------");
      print(widget.sourchat.number + " ," + widget.chatModel.number);
      print(
          "----------------------------------------------------------------------");
      request.files.add(MultipartFile.fromBytes(
          "video", File(widget.path).readAsBytesSync(),
          filename: widget.path.toString().split("/").last));
      //request.fields["video"] = video;
      request.fields["receive_number"] = "623258695";
      request.fields["send_number"] = "650123458";
      var response = await request.send();

      print(
          "----------------------------------------------------------------------");
      print(response.statusCode);
      print(
          "----------------------------------------------------------------------");

      /*var res = await Response.fromStream(response);*/
      if (response.statusCode == 406) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => IndividualPage(
                      chatModel: widget.chatModel,
                      sourchat: widget.sourchat,
                      path: widget.path,
                    )));
      } else {
        print('error status: ${response.statusCode}');
        throw "Unable to save user: Server Error";
      }
    } catch (e) {
      print(e);
      throw ".....not ok !!!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        backgroundColor: Colors.black,
      ),*/
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: IconButton(
                            icon: Transform.rotate(
                              angle: 90,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onPressed: () async {
                              _stockeVideo();
                              /*Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => IndividualPage(
                                            chatModel: widget.chatModel,
                                            sourchat: widget.sourchat,
                                            path: widget.path,
                                          )));*/
                            }),
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black38,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
