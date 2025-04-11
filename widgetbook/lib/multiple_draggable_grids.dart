import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/grid_view.dart';
import 'package:widgetbook_workspace/widgets/info_label.dart';

@widgetbook.UseCase(
  name: 'Multiple Draggable Grids',
  type: DraggableBuilder,
)
Widget buildMultipleDraggableBuilderUseCase(BuildContext context) {
  return MultipleDraggableBuilderUseCase();
}

class MultipleDraggableBuilderUseCase extends StatefulWidget {
  const MultipleDraggableBuilderUseCase({super.key});

  @override
  State<MultipleDraggableBuilderUseCase> createState() => _MultipleDraggableBuilderUseCaseState();
}

class _MultipleDraggableBuilderUseCaseState extends State<MultipleDraggableBuilderUseCase> {
  late final DraggableController _controller;

  static const topIdentifier = 0;
  static const bottomIdentifier = 1;

  var _topItems = rgbColors.toItems();
  var _bottomItems = cmyColors.toItems();

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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            InfoLabel(
              labelText: "Top Draggable GridView",
              child: DraggableGridView(
                identifier: topIdentifier,
                controller: _controller,
                itemCount: _topItems.length,
                valueProvider: (i) => _topItems[i],
                itemBuilder: itemBuilder,
                itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                feedbackBuilder: feedbackBuilder,
                feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
                placeholderBuilder: placeholderBuilder,
                emptyItemBuilder: emptyItemBuilder,
              ),
            ),
            InfoLabel(
              labelText: "Bottom Draggable GridView",
              child: DraggableGridView(
                identifier: bottomIdentifier,
                controller: _controller,
                itemCount: _bottomItems.length,
                valueProvider: (i) => _bottomItems[i],
                itemBuilder: itemBuilder,
                itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                feedbackBuilder: feedbackBuilder,
                feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
                placeholderBuilder: placeholderBuilder,
                emptyItemBuilder: emptyItemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    var newTopColors = [..._topItems];
    var newBottomColors = [..._bottomItems];

    final dragColors = dragId == topIdentifier ? newTopColors : newBottomColors;
    final targetColors = targetId == topIdentifier ? newTopColors : newBottomColors;

    final color = dragColors.removeAt(dragIndex);
    targetColors.insert(targetIndex, color);

    setState(() {
      _topItems = newTopColors;
      _bottomItems = newBottomColors;
    });
  }
}
