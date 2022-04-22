import 'package:QuizProjectJonathan/markers/markers.dart';
import 'package:flutter/material.dart';

class TextMarkerScreen extends StatelessWidget {
  const TextMarkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            color: Colors.red,
            width: 350,
            height: 350,
            child: CustomPaint(
              painter: StartMarkerPointer(),
            )),
      ),
    );
  }
}
