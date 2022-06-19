import 'dart:math';

import 'package:camera/camera.dart';
import 'package:videomail/CameraView.dart';
import 'package:videomail/Model/ChatModel.dart';
import 'package:videomail/VideoView.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  final ChatModel chatModel;
  final ChatModel sourchat;

  const CameraScreen(
      {Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    //Request all available cameras from the camera plugin
    cameras = await availableCameras();
    print("----------------------------------------------");
    print("----------------------------------------------");
    print(cameras[1]);
    print("----------------------------------------------");
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_cameraController));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
              bottom: 0.0,
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(
                              flash ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                              flash
                                  ? _cameraController
                                      .setFlashMode(FlashMode.torch)
                                  : _cameraController
                                      .setFlashMode(FlashMode.off);
                            }),
                        GestureDetector(
                          onLongPress: () async {
                            await _cameraController.startVideoRecording();
                            setState(() {
                              isRecoring = true;
                            });
                          },
                          onLongPressUp: () async {
                            XFile videopath =
                                await _cameraController.stopVideoRecording();
                            setState(() {
                              isRecoring = false;
                            });
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => VideoViewPage(
                                          path: videopath.path,
                                          chatModel: widget.chatModel,
                                          sourchat: widget.sourchat,
                                        )));
                          },
                          onTap: () {
                            if (!isRecoring) takePhoto(context);
                          },
                          child: isRecoring
                              ? Icon(
                                  Icons.radio_button_on,
                                  color: Colors.red,
                                  size: 80,
                                )
                              : Icon(
                                  Icons.panorama_fish_eye,
                                  color: Colors.white,
                                  size: 70,
                                ),
                        ),
                        IconButton(
                            icon: Transform.rotate(
                              angle: transform,
                              child: Icon(
                                Icons.flip_camera_ios,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                iscamerafront = !iscamerafront;
                                transform = transform + pi;
                              });
                              int cameraPos = iscamerafront ? 0 : 1;
                              _cameraController = CameraController(
                                  cameras[cameraPos], ResolutionPreset.high);
                              cameraValue = _cameraController.initialize();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Hold for Video, tap for photo",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                  path: file.path,
                )));
  }
}
