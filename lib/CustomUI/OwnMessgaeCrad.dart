import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OwnMessageCard extends StatefulWidget {
  const OwnMessageCard({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  _OwnMessageCardState createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      });
  }

  @override
  Widget build(BuildContext context) {
    return //Scaffold(
        // backgroundColor: Colors.black,
        /*appBar: AppBar(
        backgroundColor: Colors.black,
      ),*/
        //body:
        Align(
      alignment: Alignment.centerRight,
      child: Card(
          //margin: EdgeInsets.only(top: 380.0, right: 10.0),
          shadowColor: Colors.black,
          shape: Border.all(),
          elevation: 300,
          child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height - 500,
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
              ))),
    );
    //);
  }
}
