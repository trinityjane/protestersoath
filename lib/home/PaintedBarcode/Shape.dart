import 'package:flutter/material.dart';

enum SHAPES { circle, triangle, square }

abstract class Shape {
  final SHAPES type;
  final Color color;

  const Shape(this.type, [this.color = Colors.blueAccent]);

  double width() => 10;
  double height() => 10;
  double minSize() => 100;
  double maxSize() => 10;
  double incircleRadius() => 10;
  Offset center() => const Offset(0, 0);

  @override
  String toString() => 'Color: [34m${color.toString()}\u001b[0m';

  void draw(Canvas canvas) {}
}
