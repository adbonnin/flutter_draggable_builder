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
Widget buildSimpleDraggableBuilderUseCase(BuildContext context) {
  return SimpleDraggableBuilderUseCase();
}

class SimpleDraggableBuilderUseCase extends StatefulWidget {
  const SimpleDraggableBuilderUseCase({super.key});

  @override
  State<SimpleDraggableBuilderUseCase> createState() => _SimpleDraggableBuilderUseCaseState();
}

class _SimpleDraggableBuilderUseCaseState extends State<SimpleDraggableBuilderUseCase> {
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
    final feedbackBuilder = context.knobs.feedbackBuilder();
    final feedbackConstraintsSameAsItem = context.knobs.feedbackConstraintsSameAsItem();
    final placeholderBuilder = context.knobs.placeholderBuilder();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: DraggableGridView(
          identifier: 0,
          controller: _controller,
          itemCount: _items.length,
          valueProvider: (i) => _items[i],
          itemBuilder: itemBuilder,
          feedbackBuilder: feedbackBuilder,
          feedbackConstraintsSameAsItem: feedbackConstraintsSameAsItem,
          placeholderBuilder: placeholderBuilder,
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
