import 'package:flutter/material.dart';

import 'Circle.dart';
import 'Triangle.dart';
import 'Square.dart';
import 'Shape.dart';

class PaintedBarcode {
  List<Shape> shapes;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
    Colors.orange,
    Colors.indigo,
  ];
  final List<Color> alt_colors = [
    Colors.redAccent.shade100,
    Colors.greenAccent.shade200,
    Colors.indigoAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.pink.shade100,
    Colors.cyanAccent.shade100,
    Colors.lightGreenAccent.shade200,
    Colors.deepOrange,
    Colors.orangeAccent.shade100,
    Colors.indigo.shade300,
  ];
  final List<Color> alt_alt_colors = [
    Colors.blueGrey,
    Colors.brown,
    Colors.lime,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  PaintedBarcode(List<Shape> shapes) : shapes = shapes;

  List<Shape> shapeShape(Shape shape, int direction, Color color, int repeat) {
    if (shape.type == SHAPES.circle) {
      return (shape as Circle).splitCircle(direction % 2, color);
    }
    if (shape.type == SHAPES.triangle) {
      return (shape as Triangle).splitTriangle(direction % 3, color);
    }
    if (shape.type == SHAPES.square) {
      return (shape as Square).splitRect(direction % 4, color);
    }
    return [shape];
  }

  List<Shape> spread(List<Shape> thisList) {
    List<Shape> value = [];
    for (var element in thisList) {
      value.add(element);
    }
    return value;
  }

  List<Shape> split(List<Shape> shapeList, int which, int direction, Color color, int repeat) {
    if (shapeList.isEmpty) return [];
    int safeIndex = which % shapeList.length;
    List<Shape> shapes = List<Shape>.from(shapeList);
    Shape toSplit = shapes.removeAt(safeIndex);
    return [...shapes, ...shapeShape(toSplit, direction, color, repeat)];
  }

  void makePainting(String phone, double width, double height) {
    List<String> digits = phone.split('');
    RegExp digitChars = RegExp(r'[0-9]');
    digits = digits.where((digit) => digitChars.hasMatch(digit)).toList();
    if (digits.isEmpty) return; // Defensive: do not proceed if no digits
    List<int> digitInts = digits.map((d) => int.parse(d)).toList();
    int length = digitInts.length;
    final Rect rect = Rect.fromLTWH(0, 0, width, height);
    int colorIndex = digitInts[(digitInts[0]) % length] % alt_alt_colors.length;
    Color colorBase = alt_alt_colors[colorIndex];
    shapes.add(Square(rect, colorBase));
    List<int> used = [];
    List<int> used2 = [];
    for (var index = 0; index < digitInts.length; index++) {
      int digitOb = digitInts[index] % 10;
      int direction = (digitOb < 4)
          ? 1 // vertical
          : (digitOb < 8)
              ? 0 // horizontal
              : (digitOb < 9)
                  ? 2
                  : 3;
      int colorIndex = digitInts[(index + 2) % length] % colors.length;
      Color color = colors[colorIndex];
      if (used.contains(colorIndex)) {
        int colorIndex2 = index % alt_colors.length;
        color = alt_colors[colorIndex2];
        if (used2.contains(colorIndex2)) {
          int colorIndex3 = (index + 1) % alt_alt_colors.length;
          color = alt_alt_colors[colorIndex3];
        }
        used2.add(colorIndex2);
      }
      used.add(colorIndex);
      int repeat = digitInts[(index + 2) % length] % 2;
      int which = digitInts[(index + 3) % length] % shapes.length;
      shapes = split(shapes, which, direction, color, repeat);
    }
    used = [];
    used2 = [];
    for (var index = 0; index < digitInts.length; index++) {
      int digit = digitInts[index];
      if (digit == 0 || digit == 3) {
        int colorIndex = digitInts[(index + 9) % length] % colors.length;
        Color color = colors[colorIndex % colors.length];
        if (used.contains(colorIndex)) {
          int colorIndex2 = (index + 3) % alt_colors.length;
          color = alt_colors[colorIndex2];
          if (used2.contains(colorIndex2)) {
            int colorIndex3 = (index + 4) % alt_alt_colors.length;
            color = alt_alt_colors[colorIndex3];
          }
          used2.add(colorIndex2);
        }
        used.add(colorIndex);
        if (index < shapes.length) {
          shapes.add(Circle.fromShape(shapes[index], color));
        }
      }
    }
  }

  void arrayDraw(Canvas canvas, List<Shape> shapes) {
    for (var shape in shapes) {
      shape.draw(canvas);
    }
  }

  @override
  String toString() {
    if (shapes.isEmpty) return '<>';
    String value = "<" + shapes.first.toString();
    shapes.skip(1).forEach((element) {
      value = value + ", " + element.toString();
    });
    return value + ">";
  }

  void draw(Canvas canvas) {
    arrayDraw(canvas, shapes);
  }
}
