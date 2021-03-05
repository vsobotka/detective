import 'package:detective/views/gallery_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DetectiveApp());
}

class DetectiveApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DetectiveApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryView(title: 'DetectiveApp')
    );
  }
}
