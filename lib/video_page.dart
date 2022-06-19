import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'package:videomail/confirmPage.dart';
//import 'package:videomail/connection.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  String video = "";

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(false);
    await _videoPlayerController.pause();
  }

  _stockeVideo() async {
    await GallerySaver.saveVideo(widget.filePath);
    _sendMessage();
    //File(widget.filePath).deleteSync();
  }

  _sendMessage() async {
    try {
      //int receive_number = 650082764;
      //int send_number = 650083259;

      var request =
          MultipartRequest("POST", Uri.parse("http://192.168.56.1:8082/chat"));
      print(
          "----------------------------------------------------------------------");
      print(widget.filePath);
      print(
          "----------------------------------------------------------------------");
      request.files.add(MultipartFile.fromBytes(
          "video", File(widget.filePath).readAsBytesSync(),
          filename: widget.filePath.toString().split("/").last));
      // request.fields["video"] = video;
      request.fields["receive_number"] = "623256789";
      request.fields["send_number"] = "641247856";
      var response = await request.send();

      var res = await Response.fromStream(response);
      /*if (res.statusCode == 201) {
        Map<String, dynamic> body = jsonDecode(res.body);
        print(body);
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StatusPage()),
            (route) => false);*/
      } else {
        print('error status: ${res.statusCode}');
        print('error body: ${jsonDecode(res.body)}');
        throw "Unable to save user: Server Error";
      }*/
    } catch (e) {
      print(e);
      throw ".....not ok !!!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Votre Vidéo'),
          elevation: 0,
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                /*final route = MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => ConfirmPage(filePath: widget.filePath),
                );*/
                //_stockeVideo();
              },
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: _initVideoPlayer(),
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return VideoPlayer(_videoPlayerController);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              _videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              //setState(() {
              // If the video is playing, pause it.
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
              } else {
                // If the video is paused, play it.
                _videoPlayerController.play();
              }
              //});
            }));
  }
}
