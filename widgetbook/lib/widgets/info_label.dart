import 'package:flutter/material.dart';

class InfoLabel extends StatelessWidget {
  const InfoLabel({
    super.key,
    required this.labelText,
    required this.child,
  });

  final String labelText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final themeColor = switch (themeData.brightness) {
      Brightness.light => themeData.colorScheme.primary,
      Brightness.dark => themeData.colorScheme.secondary,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 4),
          child: Text(
            labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
