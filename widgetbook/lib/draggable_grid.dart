import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/grid_view.dart';

@widgetbook.UseCase(
  name: 'Draggable Grid',
  type: DraggableBuilder,
)
Widget buildDraggableGridUseCase(BuildContext context) {
  return DraggableGridUseCase();
}

class DraggableGridUseCase extends StatefulWidget {
  const DraggableGridUseCase({super.key});

  @override
  State<DraggableGridUseCase> createState() => _DraggableGridUseCaseState();
}

class _DraggableGridUseCaseState extends State<DraggableGridUseCase> {
  late final DraggableController _controller;

  var _items = rgbColors.toItems();

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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: DraggableGridView(
          identifier: 0,
          isLongPress: context.knobs.isLongPress(),
          controller: _controller,
          axis: context.knobs.axis(),
          feedbackConstraintsSameAsItem: context.knobs.feedbackConstraintsSameAsItem(),
          dragAnchorStrategy: context.knobs.dragAnchorStrategy(),
          affinity: context.knobs.affinity(),
          itemBuilder: itemBuilder,
          feedbackBuilder: context.knobs.feedbackBuilder(),
          placeholderBuilder: context.knobs.placeholderBuilder(),
          valueProvider: (i) => _items[i],
          itemCount: _items.length,
        ),
      ),
    );
  }

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    final color = _items[dragIndex];

    final newColors = [..._items] //
      ..removeAt(dragIndex)
      ..insert(targetIndex, color);

    setState(() {
      _items = newColors;
    });
  }
}
