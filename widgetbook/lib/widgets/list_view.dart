import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class DraggableInfiniteListView<T> extends StatelessWidget {
  const DraggableInfiniteListView({
    super.key,
    required this.identifier,
    required this.valueProvider,
    this.controller,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.placeholderBuilder,
    this.feedbackBuilder,
    this.emptyItemBuilder,
  });

  final int identifier;
  final IndexedValueBuilder<T> valueProvider;
  final DraggableController? controller;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? itemWhenDraggingBuilder;
  final Widget Function(BuildContext context, T value)? placeholderBuilder;
  final Widget Function(BuildContext context, T value)? feedbackBuilder;
  final Widget Function(BuildContext context)? emptyItemBuilder;

  @override
  Widget build(BuildContext context) {
    return DraggableBuilder(
      identifier: identifier,
      controller: controller,
      itemBuilder: (c, i) => itemBuilder(c, valueProvider(i)),
      itemWhenDraggingBuilder: itemWhenDraggingBuilder == null ? null : (c, i) => itemWhenDraggingBuilder!(c, valueProvider(i)),
      feedbackBuilder: feedbackBuilder == null ? null : (c, i) => feedbackBuilder!(c, valueProvider(i)),
      feedbackSizeSameAsItem: false,
      placeholderBuilder: placeholderBuilder == null ? null : (c, i, _, __) => placeholderBuilder!(c, valueProvider(i)),
      emptyItemBuilder: emptyItemBuilder,
      itemCount: null,
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
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
