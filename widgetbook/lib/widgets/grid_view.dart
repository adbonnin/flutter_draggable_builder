import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableGridView<T> extends StatelessWidget {
  const DraggableGridView({
    super.key,
    required this.identifier,
    this.isLongPress = false,
    this.controller,
    this.axis,
    this.feedbackConstraintsSameAsItem = true,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.feedbackBuilder,
    this.placeholderBuilder,
    this.emptyItemBuilder,
    required this.valueProvider,
    this.itemCount,
  });

  final int identifier;
  final bool isLongPress;
  final DraggableController? controller;
  final Axis? axis;
  final bool feedbackConstraintsSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? itemWhenDraggingBuilder;
  final Widget Function(BuildContext context, T value)? feedbackBuilder;
  final Widget Function(BuildContext context, T value)? placeholderBuilder;
  final Widget Function(BuildContext context)? emptyItemBuilder;
  final IndexedValueProvider<T> valueProvider;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return DraggableBuilder(
      identifier: identifier,
      isLongPress: isLongPress,
      controller: controller,
      axis: axis,
      feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
      dragAnchorStrategy: dragAnchorStrategy,
      affinity: affinity,
      itemBuilder: (c, i) => itemBuilder(c, valueProvider(i)),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, i) => itemWhenDraggingBuilder!(c, valueProvider(i)),
      feedbackBuilder: feedbackBuilder == null ? null : (c, i) => feedbackBuilder!(c, valueProvider(i)),
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
