import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:videomail/CameraScreen.dart';
import 'package:videomail/camera_page_1.dart';
import 'package:videomail/Homescreen.dart';
import 'package:videomail/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "OpenSans",
          primaryColor: Color(0xFF075E54),
          accentColor: Color(0xFF128C7E)),
      home: LoginScreen(),
    );
  }
}
