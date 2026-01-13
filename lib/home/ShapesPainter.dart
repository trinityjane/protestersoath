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
    final String normalizedPhone = stripPlusOnePhone(phoneNumber);

    PaintedBarcode painting = PaintedBarcode(shapes);
    painting.makePainting(normalizedPhone, size.width, size.height);
    // Always draw at least one shape if nothing is generated
    if (shapes.isEmpty) {
      final paint = Paint()..color = Colors.grey.withOpacity(0.3);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'No code',
          style: TextStyle(color: Colors.black45, fontSize: 32),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(size.width/2 - textPainter.width/2, size.height/2 - textPainter.height/2));
    } else {
      painting.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
