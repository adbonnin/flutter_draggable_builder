import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableGridView<T> extends StatelessWidget {
  const DraggableGridView({
    super.key,
    required this.identifier,
    this.controller,
    this.itemCount,
    required this.valueProvider,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.placeholderBuilder,
    this.feedbackBuilder,
    this.feedbackConstraintsSameAsItem = true,
    this.emptyItemBuilder,
  });

  final int identifier;
  final DraggableController? controller;
  final int? itemCount;
  final IndexedValueProvider<T> valueProvider;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? itemWhenDraggingBuilder;
  final Widget Function(BuildContext context, T value)? placeholderBuilder;
  final Widget Function(BuildContext context, T value)? feedbackBuilder;
  final bool feedbackConstraintsSameAsItem;
  final Widget Function(BuildContext context)? emptyItemBuilder;

  @override
  Widget build(BuildContext context) {
    return DraggableBuilder(
      identifier: identifier,
      controller: controller,
      itemBuilder: (c, i) => itemBuilder(c, valueProvider(i)),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, i) => itemWhenDraggingBuilder!(c, valueProvider(i)),
      feedbackBuilder: feedbackBuilder == null ? null : (c, i) => feedbackBuilder!(c, valueProvider(i)),
      feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
      placeholderBuilder: placeholderBuilder == null ? null : (c, i, _, __) => placeholderBuilder!(c, valueProvider(i)),
      emptyItemBuilder: emptyItemBuilder,
      itemCount: itemCount,
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
