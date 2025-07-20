import 'package:flutter/material.dart';

class ColorMapper {
  static Color fromName(String name) {
    switch (name.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'yellow':
        return Colors.yellow;
      case 'white':
        return Colors.white;
      case 'pink':
        return Colors.pink;
      case 'grey':
        return Colors.grey;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'brown':
        return Colors.brown;
      default:
        return Colors.grey.shade400; // fallback/default color
    }
  }
}
