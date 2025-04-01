import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/grid_item.dart';
import 'package:widgetbook_workspace/widgets/grid_view.dart';
import 'package:widgetbook_workspace/widgets/info_label.dart';

@widgetbook.UseCase(
  name: 'Multiple',
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

  static const topId = 0;
  static const bottomId = 1;

  var _topColors = [Colors.red, Colors.green];
  var _bottomColors = <Color>[Colors.blue, Colors.yellow];

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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            InfoLabel(
              labelText: "Top Draggable GridView",
              child: DraggableGridView(
                id: topId,
                values: _topColors,
                controller: _controller,
                itemBuilder: (_, color) => GridItem(color: color),
                itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                feedbackBuilder: feedbackBuilder,
                placeholderBuilder: placeholderBuilder,
                emptyItemBuilder: emptyItemBuilder,
              ),
            ),
            InfoLabel(
              labelText: "Bottom Draggable GridView",
              child: DraggableGridView(
                id: bottomId,
                values: _bottomColors,
                controller: _controller,
                itemBuilder: (_, color) => GridItem(color: color),
                itemWhenDraggingBuilder: itemWhenDraggingBuilder,
                feedbackBuilder: feedbackBuilder,
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
    var newTopColors = [..._topColors];
    var newBottomColors = [..._bottomColors];

    final dragColors = dragId == topId ? newTopColors : newBottomColors;
    final targetColors = targetId == topId ? newTopColors : newBottomColors;

    final color = dragColors.removeAt(dragIndex);
    targetColors.insert(targetIndex, color);

    setState(() {
      _topColors = newTopColors;
      _bottomColors = newBottomColors;
    });
  }
}
