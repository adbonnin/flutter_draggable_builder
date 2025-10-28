import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableGridView<ID, T> extends StatelessWidget {
  const DraggableGridView({
    super.key,
    required this.identifier,
    this.isLongPress = false,
    this.controller,
    this.axis,
    this.feedbackConstraintsSameAsItem = true,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    this.wrapWithDragTarget = false,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.feedbackBuilder,
    this.placeholderBuilder,
    this.emptyItemBuilder,
    required this.valueProvider,
    this.itemCount,
  });

  final ID identifier;
  final bool isLongPress;
  final DraggableController<ID, T>? controller;
  final Axis? axis;
  final bool feedbackConstraintsSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
  final bool wrapWithDragTarget;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? itemWhenDraggingBuilder;
  final Widget Function(BuildContext context, T value)? feedbackBuilder;
  final Widget Function(BuildContext context, T value)? placeholderBuilder;
  final Widget Function(BuildContext context)? emptyItemBuilder;
  final ItemProvider<T> valueProvider;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return DraggableBuilder<ID, T>(
      identifier: identifier,
      isLongPress: isLongPress,
      controller: controller,
      axis: axis,
      feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
      dragAnchorStrategy: dragAnchorStrategy,
      affinity: affinity,
      wrapWithDragTarget: wrapWithDragTarget,
      itemBuilder: (c, v, i) => itemBuilder(c, v),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, v, i) => itemWhenDraggingBuilder!(c, v),
      feedbackBuilder: feedbackBuilder == null ? null : (c, v, i) => feedbackBuilder!(c, v),
      placeholderBuilder: placeholderBuilder == null ? null : (c, d) => placeholderBuilder!(c, d.dragItem),
      emptyItemBuilder: emptyItemBuilder,
      itemCount: itemCount,
      itemProvider: valueProvider,
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
