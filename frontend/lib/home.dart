import 'package:flutter/material.dart';
import 'package:frontend/camera.dart';
import 'package:frontend/info.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CameraWidget(),
        '/upload': (context) => Info(),
      },
    );
  }
}
