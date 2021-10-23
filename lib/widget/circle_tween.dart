import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';

class CircleTween extends Tween<Offset> {

  final double radius;
  CircleTween(this.radius): super(
    begin: _radiansToOffset(0, radius),
    end: _radiansToOffset(2*pi, radius)
  );

  @override
  Offset lerp(double t) => _radiansToOffset(t, radius);

  static Offset _radiansToOffset(double radians, double radius) {
    return Offset(
      radius+radius*cos(radians),
      radius+radius*sin(radians),
    );
  }

}