import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey,
      child: SizedBox.expand(
        child: FittedBox(
          child: Icon(
            color: Colors.white,
            Icons.file_download,
          ),
        ),
      ),
    );
  }
}
