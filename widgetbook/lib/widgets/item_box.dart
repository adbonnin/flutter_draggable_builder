import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  const ItemBox({
    super.key,
    required this.color,
    this.text,
  });

  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
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
