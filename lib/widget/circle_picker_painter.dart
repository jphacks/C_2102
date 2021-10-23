import 'dart:math';

import 'package:flutter/cupertino.dart';

class CirclePickerPainter extends CustomPainter{

  final double strokeWidth;

  CirclePickerPainter(this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width/2, size.height/2);
    double radio = min(size.width, size.height)/2-strokeWidth;

    const sweepGradient = SweepGradient(
      colors: const[
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ]
    );
    final sweepShader = sweepGradient.createShader(
      Rect.fromLTWH(0, 0, radio, radio),
    );

    canvas.drawCircle(
      center, 
      radio, 
      Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth*2
      ..shader = sweepShader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
  

}