import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableListView<ID, T> extends StatelessWidget {
  const DraggableListView({
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

  final ID identifier;
  final bool isLongPress;
  final DraggableController<ID, T>? controller;
  final Axis? axis;
  final bool feedbackConstraintsSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
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
      itemBuilder: (c, v, i) => itemBuilder(c, v),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, v, i) => itemWhenDraggingBuilder!(c, v),
      feedbackBuilder: feedbackBuilder == null ? null : (c, v, i) => feedbackBuilder!(c, v),
      placeholderBuilder: placeholderBuilder == null ? null : (c, d) => placeholderBuilder!(c, d.dragItem),
      emptyItemBuilder: emptyItemBuilder,
      itemCount: itemCount,
      itemProvider: valueProvider,
      builder: (_, itemBuilder, itemCount) => MyListView(
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      ),
    );
  }
}

class MyListView extends StatelessWidget {
  const MyListView({
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
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (c, i) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: itemBuilder(c, i),
      ),
      itemCount: itemCount,
    );
  }
}
