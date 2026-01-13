import 'package:flutter/material.dart';

import 'Shape.dart';

class Circle extends Shape {
  @override
  final Offset offset;
  final double radius;

  Circle(this.offset, this.radius, [Color color = Colors.amberAccent])
      : super(SHAPES.circle, color);

  @override
  Offset center() => offset;

  @override
  double minSize() => radius / 2;

  Circle.fromShape(Shape shape, [Color color = Colors.blueAccent])
      : offset = shape.center(),
        radius = shape.incircleRadius(),
        super(SHAPES.circle, color);

  List<Shape> splitCircle(int direction, [Color? color]) {
    final splitColor = color ?? this.color;
    if (direction == 0) {
      return [this];
    } else {
      return [this, Circle(offset, radius / 2, splitColor)];
    }
  }

  @override
  String toString() {
    return "Circle[ $offset, $radius, ${super.toString()} ]\n";
  }

  @override
  void draw(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(offset, radius, paint);
  }
}
