import 'package:flutter/material.dart';
//import 'package:whatapp_clone_ui/pages/uiChat/view/camera_page_1.dart';
//import 'package:whatapp_clone_ui/pages/uiStreaming/settings_page.dart';

final String individualPage = '/individualPage';
final String cameraPage = '/cameraPage';
final String cameraScreenPage = '/cameraScreenPage';
final String videoViewPage = '/videoViewPage';

Map<String, WidgetBuilder> AppRoutes() {
  return <String, WidgetBuilder>{
    //route pour atteindre la setting page ( /setting )
    //exploreSettingMenu: ((context) => SettingsPage()),

    //exemple url /exemple  pour atteindre la page camera
    //exemple: (context) => CameraPage(),
  };
}
