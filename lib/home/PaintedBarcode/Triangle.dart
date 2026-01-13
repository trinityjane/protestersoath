import 'dart:math';
import 'package:flutter/material.dart';

import 'Shape.dart';

class Triangle extends Shape {
  final List<Point<double>> points;

  Triangle(List<Point<double>> points, [Color color = Colors.pinkAccent])
      : points = List<Point<double>>.from(points),
        super(SHAPES.triangle, color);

  Triangle.fromPoints(Point<double> p0, Point<double> p1, Point<double> p2,
      [Color color = Colors.pinkAccent])
      : points = [p0, p1, p2],
        super(SHAPES.triangle, color);

  List<Shape> split() {
    return [this, this];
  }

  double length(Point<double> a, Point<double> b) {
    return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y));
  }

  @override
  double minSize() {
    final A = points[0];
    final B = points[1];
    final C = points[2];
    final c = length(A, B);
    final a = length(B, C);
    final b = length(C, A);
    final perimeter = a + b + c;
    final p = perimeter / 2;
    final area = sqrt(p * (p - a) * (p - b) * (p - c));
    return 2 * area / perimeter;
  }

  @override
  double incircleRadius() => minSize();

  Point<double> inCenter() {
    final A = points[0];
    final B = points[1];
    final C = points[2];
    final c = length(A, B);
    final a = length(B, C);
    final b = length(C, A);
    final divisor = a + b + c;
    return Point<double>(
        (A.x * a + B.x * b + C.x * c) / divisor, (A.y * a + B.y * b + C.y * c) / divisor);
  }

  @override
  Offset center() {
    final center = inCenter();
    return Offset(center.x, center.y);
  }

  Point<double> naturalCenter() {
    return Point<double>(
        (points[0].x + points[1].x + points[2].x) / 3,
        (points[0].y + points[1].y + points[2].y) / 3);
  }

  Point<double> midpoint(Point<double> p0, Point<double> p1) {
    return Point<double>((p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
  }

  List<Shape> splitTriangle(int direction, [Color? color]) {
    int p1, p2, p0;
    final splitColor = color ?? this.color;
    switch (direction) {
      case 0:
        p0 = 0;
        p1 = 1;
        p2 = 2;
        break;
      case 1:
        p0 = 2;
        p1 = 0;
        p2 = 1;
        break;
      case 2:
      default:
        p0 = 1;
        p1 = 2;
        p2 = 0;
        break;
    }
    final center = midpoint(points[p1], points[p2]);
    return [
      Triangle.fromPoints(points[p0], center, points[p1], this.color),
      Triangle.fromPoints(points[p0], center, points[p2], splitColor)
    ];
  }

  @override
  String toString() {
    return "Triangle[ " +
        points[0].toString() +
        ", " +
        points[1].toString() +
        ", " +
        points[2].toString() +
        " ]\n";
  }

  @override
  void draw(Canvas canvas) {
    final paint = Paint();
    paint.color = this.color;
    final Path path = Path();
    path.moveTo(points[0].x, points[0].y);
    path.lineTo(points[1].x, points[1].y);
    path.lineTo(points[2].x, points[2].y);
    path.close();
    canvas.drawPath(path, paint);
  }
}
