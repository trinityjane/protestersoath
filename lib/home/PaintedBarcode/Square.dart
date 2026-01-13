import 'dart:math';
import 'package:flutter/material.dart';

import 'Triangle.dart';
import 'Shape.dart';

class Square extends Shape {
  final Rect rect;

  Square(Rect rect, [Color color = Colors.blueAccent])
      : rect = rect,
        super(SHAPES.square, color);

  Point<double> midpoint(Point<double> p0, Point<double> p1) {
    return Point((p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
  }

  double width() => rect.width;
  double height() => rect.height;

  @override
  Offset center() => rect.center;

  @override
  double incircleRadius() => minSize() / 2;

  @override
  double minSize() => width() < height() ? width() : height();

  Square.fromLTRB(double left, double top, double right, double bottom,
      [Color color = Colors.blueAccent])
      : rect = Rect.fromLTRB(left, top, right, bottom),
        super(SHAPES.square, color);

  List<Shape> splitRect(int direction, [Color? color]) {
    final splitColor = (color == null || color == Colors.transparent) ? this.color : color;
    switch (direction) {
      case 0: // horizontal
        double center = (rect.top + rect.bottom) / 2;
        return [
          Square.fromLTRB(rect.left, rect.top, rect.right, center, this.color),
          Square.fromLTRB(rect.left, center, rect.right, rect.bottom, splitColor)
        ];
      case 1: // vertical
        double center = (rect.left + rect.right) / 2;
        return [
          Square.fromLTRB(center, rect.top, rect.right, rect.bottom, this.color),
          Square.fromLTRB(rect.left, rect.top, center, rect.bottom, splitColor)
        ];
      case 2: // up diagonal
        Point<double> LT = Point(rect.left, rect.top);
        Point<double> RT = Point(rect.right, rect.top);
        Point<double> RB = Point(rect.right, rect.bottom);
        Point<double> LB = Point(rect.left, rect.bottom);
        return [
          Triangle.fromPoints(LT, RT, RB, this.color),
          Triangle.fromPoints(RB, LB, LT, splitColor)
        ];
      case 3:
      default: // down diagonal
        Point<double> LT = Point(rect.left, rect.top);
        Point<double> RT = Point(rect.right, rect.top);
        Point<double> RB = Point(rect.right, rect.bottom);
        Point<double> LB = Point(rect.left, rect.bottom);
        return [
          Triangle.fromPoints(RB, LB, RT, this.color),
          Triangle.fromPoints(RT, LT, LB, splitColor)
        ];
    }
  }

  @override
  String toString() => "Square[ $rect ]\n";

  @override
  void draw(Canvas canvas) {
    final paint = Paint();
    paint.color = color;
    canvas.drawRect(rect, paint);
  }
}
