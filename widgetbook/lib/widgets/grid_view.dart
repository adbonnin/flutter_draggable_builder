import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableGridView<T> extends StatelessWidget {
  const DraggableGridView({
    super.key,
    required this.id,
    required this.values,
    this.controller,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.placeholderBuilder,
    this.feedbackBuilder,
    this.emptyItemBuilder,
  });

  final int id;
  final List<T> values;
  final DraggableController? controller;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? itemWhenDraggingBuilder;
  final Widget Function(BuildContext context, T value)? placeholderBuilder;
  final Widget Function(BuildContext context, T value)? feedbackBuilder;
  final Widget Function(BuildContext context)? emptyItemBuilder;

  @override
  Widget build(BuildContext context) {
    return DraggableBuilder(
      id: id,
      controller: controller,
      itemBuilder: (c, i) => itemBuilder(c, values[i]),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, i) => itemWhenDraggingBuilder!(c, values[i]),
      feedbackBuilder: feedbackBuilder == null ? null : (c, i) => feedbackBuilder!(c, values[i]),
      placeholderBuilder: placeholderBuilder == null ? null : (c, i, _, __) => placeholderBuilder!(c, values[i]),
      emptyItemBuilder: emptyItemBuilder,
      itemCount: values.length,
      builder: (_, itemBuilder, itemCount) => MyGridView(
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      ),
    );
  }
}

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
