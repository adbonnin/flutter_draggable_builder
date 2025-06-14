import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/models/item.dart';
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/grid_view.dart';
import 'package:widgetbook_workspace/widgets/info_label.dart';

@widgetbook.UseCase(
  name: 'Multiple Draggable Grids',
  type: DraggableBuilder,
)
Widget buildMultipleDraggableGridsUseCase(BuildContext context) {
  return MultipleDraggableGridsUseCase();
}

class MultipleDraggableGridsUseCase extends StatefulWidget {
  const MultipleDraggableGridsUseCase({super.key});

  @override
  State<MultipleDraggableGridsUseCase> createState() => _MultipleDraggableGridsUseCaseState();
}

class _MultipleDraggableGridsUseCaseState extends State<MultipleDraggableGridsUseCase> {
  late final DraggableController<String> _controller;

  static const topIdentifier = 'top';
  static const bottomIdentifier = 'bottom';

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
    return DefaultDraggableController<String>(
      controller: _controller,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              InfoLabel(
                labelText: "Top Draggable GridView",
                child: DraggableGridView<String, Item>(
                  identifier: topIdentifier,
                  isLongPress: context.knobs.isLongPress(),
                  axis: context.knobs.axis(),
                  feedbackConstraintsSameAsItem: context.knobs.feedbackConstraintsSameAsItem(),
                  dragAnchorStrategy: context.knobs.dragAnchorStrategy(),
                  affinity: context.knobs.affinity(),
                  wrapWithDragTarget: context.knobs.wrapWithDragTarget(),
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: context.knobs.itemWhenDraggingBuilder(),
                  feedbackBuilder: context.knobs.feedbackBuilder(),
                  placeholderBuilder: context.knobs.placeholderBuilder(),
                  emptyItemBuilder: context.knobs.emptyItemBuilder(),
                  itemCount: _topItems.length,
                  valueProvider: (i) => _topItems[i],
                ),
              ),
              InfoLabel(
                labelText: "Bottom Draggable GridView",
                child: DraggableGridView<String, Item>(
                  identifier: bottomIdentifier,
                  isLongPress: context.knobs.isLongPress(),
                  axis: context.knobs.axis(),
                  feedbackConstraintsSameAsItem: context.knobs.feedbackConstraintsSameAsItem(),
                  dragAnchorStrategy: context.knobs.dragAnchorStrategy(),
                  affinity: context.knobs.affinity(),
                  wrapWithDragTarget: context.knobs.wrapWithDragTarget(),
                  itemBuilder: itemBuilder,
                  itemWhenDraggingBuilder: context.knobs.itemWhenDraggingBuilder(),
                  feedbackBuilder: context.knobs.feedbackBuilder(),
                  placeholderBuilder: context.knobs.placeholderBuilder(),
                  emptyItemBuilder: context.knobs.emptyItemBuilder(),
                  itemCount: _bottomItems.length,
                  valueProvider: (i) => _bottomItems[i],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDragCompletion(String dragId, int dragIndex, String targetId, int targetIndex) {
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
