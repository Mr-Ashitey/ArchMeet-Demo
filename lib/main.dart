import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter/video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Jitsi Meet Demo', home: VideoCall());
  }
}
