import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/info_label.dart';
import 'package:widgetbook_workspace/widgets/list_view.dart';

@widgetbook.UseCase(
  name: 'Infinite Draggable Lists',
  type: DraggableBuilder,
)
Widget buildInfiniteDraggableListsUseCase(BuildContext context) {
  return InfiniteDraggableListsUseCase();
}

class InfiniteDraggableListsUseCase extends StatefulWidget {
  const InfiniteDraggableListsUseCase({super.key});

  @override
  State<InfiniteDraggableListsUseCase> createState() => _InfiniteDraggableListsUseCaseState();
}

class _InfiniteDraggableListsUseCaseState extends State<InfiniteDraggableListsUseCase> {
  late final DraggableController _controller;

  static const leftIdentifier = 0;
  static const rightIdentifier = 1;

  final leftItems = InfiniteIndexedValueProvider(buildDefaultValueProvider(rgbColors));
  final rightItems = InfiniteIndexedValueProvider(buildDefaultValueProvider(cmyColors));

  @override
  void initState() {
    super.initState();

    _controller = DraggableController(
      onDragCompletion: _onDragCompletion,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emptyItemBuilder = context.knobs.emptyItemBuilder();
    final itemWhenDraggingBuilder = context.knobs.itemWhenDraggingBuilder();
    final feedbackBuilder = context.knobs.feedbackBuilder();
    final feedbackConstraintsSameAsItem = context.knobs.feedbackConstraintsSameAsItem();
    final placeholderBuilder = context.knobs.placeholderBuilder();

    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: InfoLabel(
              labelText: "Left Draggable ListView",
              child: Expanded(
                child: DraggableListView(
                  identifier: leftIdentifier,
                  valueProvider: leftItems.call,
                  controller: _controller,
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                  feedbackBuilder: feedbackBuilder,
                  feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
                  placeholderBuilder: placeholderBuilder,
                  emptyItemBuilder: emptyItemBuilder,
                ),
              ),
            ),
          ),
          Expanded(
            child: InfoLabel(
              labelText: "Right Draggable ListView",
              child: Expanded(
                child: DraggableListView(
                  identifier: rightIdentifier,
                  valueProvider: rightItems.call,
                  controller: _controller,
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                  feedbackBuilder: feedbackBuilder,
                  feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
                  placeholderBuilder: placeholderBuilder,
                  emptyItemBuilder: emptyItemBuilder,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    final dragColors = dragId == leftIdentifier ? leftItems : rightItems;
    final targetColors = targetId == leftIdentifier ? leftItems : rightItems;

    final color = dragColors.removeAt(dragIndex);
    targetColors.insertAt(targetIndex, color);

    setState(() {});
  }
}
