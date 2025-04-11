import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  const ItemBox({
    super.key,
    required this.color,
    this.index,
    this.label,
  });

  final Color color;
  final int? index;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = [index?.toString(), label].whereType<String>();
    final isDarkColor = color.computeLuminance() < 0.9;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        border: isDarkColor ? null : Border.all(width: 1, color: Colors.grey),
      ),
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: DefaultTextStyle(
            style: TextStyle(color: isDarkColor ? Colors.white : Colors.grey),
            child: Text(text.join(":")),
          ),
        ),
      ),
    );
  }
}
