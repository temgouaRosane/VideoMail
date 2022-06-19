import 'dart:convert';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:videomail/video_page.dart';
import 'package:http/http.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  bool _clicked = false;
  String time_record = DateTime.now().microsecondsSinceEpoch.toString();
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    //Request all available cameras from the camera plugin
    final cameras = await availableCameras();
    //Selecting the front-facing camera.
    CameraDescription side = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    if (_clicked) {
      side = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
    } /*else {
      side = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    }*/

    /*Create an instance of CameraController. We are using the CameraDescription 
  of the front camera and setting the resolution of the video to the maximum.*/
    _cameraController = CameraController(side, ResolutionPreset.max);
    //Initialize the controller with the set parameters.
    await _cameraController.initialize();
    //After the initialization, set the _isLoading state to false.
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
      //await GallerySaver.saveVideo(file.path);
      /*try {
        int receive_number = 650082764;
        int send_number = 650083259;

        var request = MultipartRequest(
            "POST", Uri.parse("http://192.168.56.1:8082/chat"));
        print(
            "----------------------------------------------------------------------");
        print(file.path);
        print(
            "----------------------------------------------------------------------");
        request.files.add(MultipartFile.fromBytes(
            "video", File(file.path).readAsBytesSync(),
            filename: file.path.toString().split("/").last));
        // request.fields["video"] = video;
        request.fields["receive_number"] = "650082764";
        request.fields["send_number"] = "620285852";
        var response = await request.send();

        /*var res = await Response.fromStream(response);
        if (res.statusCode == 201) {
          Map<String, dynamic> body = jsonDecode(res.body);
          print(body);
        } else {
          print('error status: ${res.statusCode}');
          print('error body: ${jsonDecode(res.body)}');
          throw "Unable to save user: Server Error";
        }*/
      } catch (e) {
        print(e);
        throw ".....not ok !!!!";
      }*/
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      time_record = DateTime.now().microsecondsSinceEpoch.toString();
      setState(() => _isRecording = true);
    }
  }

  _changeCamera() async {
    if (_clicked) {
      setState(() => {_clicked = false, _isLoading = true});
      _initCamera();
    } else {
      setState(() => {_clicked = true, _isLoading = true});
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(time_record),
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
          body: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_cameraController),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        child: Icon(_isRecording ? Icons.stop : Icons.circle),
                        onPressed: () => _recordVideo(),
                      ),
                      FloatingActionButton(
                          backgroundColor: Colors.red,
                          child:
                              Icon(_clicked ? Icons.emoji_people : Icons.email),
                          onPressed: () => _changeCamera()),
                      /*child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_clicked ? Icons.emoji_people : Icons.email),
                onPressed: () => _changeCamera(),*/
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
