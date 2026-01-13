import 'package:flutter/material.dart';
import 'package:protestersoath/utils/stripCorrectPhone.dart';
import 'PaintedBarcode/PaintedBarcode.dart';
import 'PaintedBarcode/Shape.dart';

class ShapesPainter extends CustomPainter {
  final String phoneNumber;
  ShapesPainter(this.phoneNumber);

  @override
  void paint(Canvas canvas, Size size) {
    // Use List<Shape> for type safety
    final List<Shape> shapes = <Shape>[];
    PaintedBarcode painting = PaintedBarcode(shapes);
    painting.makePainting(stripPlusOnePhone(phoneNumber), size.width, size.height);
    painting.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
