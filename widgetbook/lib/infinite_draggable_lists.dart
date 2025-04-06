import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/info_label.dart';
import 'package:widgetbook_workspace/widgets/item_box.dart';
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

  static final leftDefaultValueProvider = buildDefaultValueProvider(Colors.red);
  static final rightDefaultValueProvider = buildDefaultValueProvider(Colors.blue);

  var _leftColorsByIndex = <int, Color>{};
  var _rightColorsByIndex = <int, Color>{};

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
    final placeholderBuilder = context.knobs.placeholderBuilder();

    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: InfoLabel(
              labelText: "Left Draggable ListView",
              child: Expanded(
                child: DraggableInfiniteListView(
                  identifier: leftIdentifier,
                  valueProvider: buildValueProvider(_leftColorsByIndex, leftDefaultValueProvider),
                  controller: _controller,
                  itemBuilder: (_, color) => ItemBox(color: color),
                  itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                  feedbackBuilder: feedbackBuilder,
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
                child: DraggableInfiniteListView(
                  identifier: rightIdentifier,
                  valueProvider: buildValueProvider(_rightColorsByIndex, rightDefaultValueProvider),
                  controller: _controller,
                  itemBuilder: (_, color) => ItemBox(color: color),
                  itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                  feedbackBuilder: feedbackBuilder,
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
    var newLeftColorsByIndex = {..._leftColorsByIndex};
    var newRightColorsByIndex = {..._rightColorsByIndex};

    final dragColors = dragId == leftIdentifier
        ? buildValueProvider(_leftColorsByIndex, leftDefaultValueProvider, true)
        : buildValueProvider(_rightColorsByIndex, rightDefaultValueProvider, true);

    final targetColors = targetId == leftIdentifier ? newLeftColorsByIndex : newRightColorsByIndex;

    final color = dragColors(dragIndex);
    targetColors[targetIndex] = color;

    setState(() {
      _leftColorsByIndex = newLeftColorsByIndex;
      _rightColorsByIndex = newRightColorsByIndex;
    });
  }
}
