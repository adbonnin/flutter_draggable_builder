import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/models/item.dart';
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
  late final DraggableController<String, Item> _controller;

  static const leftIdentifier = 'left';
  static const rightIdentifier = 'right';

  final leftItems = InfiniteIndexedValueProvider(buildDefaultValueProvider(rgbColors));
  final rightItems = InfiniteIndexedValueProvider(buildDefaultValueProvider(cmyColors));

  @override
  void initState() {
    super.initState();
    _controller = DraggableController(onDragCompletion: _onDragCompletion);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: InfoLabel(
              labelText: "Left Draggable ListView",
              child: Expanded(
                child: DraggableListView<String, Item>(
                  identifier: leftIdentifier,
                  isLongPress: context.knobs.isLongPress(),
                  controller: _controller,
                  axis: context.knobs.axis(),
                  feedbackConstraintsSameAsItem: context.knobs.feedbackConstraintsSameAsItem(),
                  dragAnchorStrategy: context.knobs.dragAnchorStrategy(),
                  affinity: context.knobs.affinity(),
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: context.knobs.itemWhenDraggingBuilder(),
                  feedbackBuilder: context.knobs.feedbackBuilder(),
                  placeholderBuilder: context.knobs.placeholderBuilder(),
                  emptyItemBuilder: context.knobs.emptyItemBuilder(),
                  valueProvider: leftItems.call,
                ),
              ),
            ),
          ),
          Expanded(
            child: InfoLabel(
              labelText: "Right Draggable ListView",
              child: Expanded(
                child: DraggableListView<String, Item>(
                  identifier: rightIdentifier,
                  isLongPress: context.knobs.isLongPress(),
                  controller: _controller,
                  axis: context.knobs.axis(),
                  feedbackConstraintsSameAsItem: context.knobs.feedbackConstraintsSameAsItem(),
                  dragAnchorStrategy: context.knobs.dragAnchorStrategy(),
                  affinity: context.knobs.affinity(),
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: context.knobs.itemWhenDraggingBuilder(),
                  feedbackBuilder: context.knobs.feedbackBuilder(),
                  placeholderBuilder: context.knobs.placeholderBuilder(),
                  emptyItemBuilder: context.knobs.emptyItemBuilder(),
                  valueProvider: rightItems.call,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragCompletion(DraggedDetails<String, Item> data) {
    final dragColors = data.dragIdentifier == leftIdentifier ? leftItems : rightItems;
    final targetColors = data.targetIdentifier == leftIdentifier ? leftItems : rightItems;

    dragColors.removeAt(data.dragIndex);
    targetColors.insertAt(data.targetIndex, data.dragValue);

    setState(() {});
  }
}
