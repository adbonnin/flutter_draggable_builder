import 'package:flutter/widgets.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({
    super.key,
    required this.itemBuilder,
    this.itemCount,
    this.crossAxisCount = 4,
  });

  final NullableIndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
