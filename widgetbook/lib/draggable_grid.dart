import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/widget_book.dart';
import 'package:widgetbook_workspace/widgets/item_box.dart';
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

  var _colors = [Colors.red, Colors.yellow, Colors.green, Colors.blue];

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
    final placeholderBuilder = context.knobs.placeholderBuilder();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: DraggableGridView(
          identifier: 0,
          values: _colors,
          controller: _controller,
          itemBuilder: (_, color) => ItemBox(color: color),
          feedbackBuilder: feedbackBuilder,
          placeholderBuilder: placeholderBuilder,
        ),
      ),
    );
  }

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    final color = _colors[dragIndex];

    final newColors = [..._colors] //
      ..removeAt(dragIndex)
      ..insert(targetIndex, color);

    setState(() {
      _colors = newColors;
    });
  }
}
