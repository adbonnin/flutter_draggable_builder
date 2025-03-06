import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Simple',
  type: DraggableBuilder,
)
Widget buildDraggableBuilderUseCase(BuildContext context) {
  return DraggableBuilderUseCase();
}

class DraggableBuilderUseCase extends StatefulWidget {
  const DraggableBuilderUseCase({super.key});

  @override
  State<DraggableBuilderUseCase> createState() => _DraggableBuilderUseCaseState();
}

class _DraggableBuilderUseCaseState extends State<DraggableBuilderUseCase> {
  var _colors = [Colors.red, Colors.yellow, Colors.green, Colors.blue];

  late final DraggableController _controller;

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
    return DraggableBuilder(
      controller: _controller,
      itemBuilder: (_, index) => ColoredBox(color: _colors[index]),
      itemCount: _colors.length,
      builder: (_, itemBuilder, itemCount) => GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      ),
    );
  }

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    final newColors = [..._colors] //
      ..removeAt(dragIndex)
      ..insert(targetIndex, _colors[dragIndex]);

    setState(() {
      _colors = newColors;
    });
  }
}
