import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.color,
    this.text,
  });

  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: Text(text ?? ''),
          ),
        ),
      ),
    );
  }
}
