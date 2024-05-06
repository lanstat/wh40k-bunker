import 'package:flutter/material.dart';

enum LabelSize {
  small,
  medium,
  title
}

class Label extends StatelessWidget {
  final LabelSize labelSize;
  final Color color;
  final String text;
  final TextAlign textAlign;

  const Label(
      this.text,
      {
        super.key,
        this.labelSize = LabelSize.medium,
        this.color = Colors.black,
        this.textAlign = TextAlign.start,
      }
      );

  double _getSize() {
    switch (labelSize) {
      case LabelSize.title:
        return 32;
      case LabelSize.medium:
        return 16;
      case LabelSize.small:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: _getSize(),
      ),
      textAlign: textAlign,
    );
  }
}