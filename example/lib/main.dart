import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Builder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _colors = <Color>[Colors.red, Colors.yellow, Colors.green, Colors.blue];

  late final DraggableController<String, Color> _controller;

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
    return Scaffold(
      body: DraggableBuilder<String, Color>(
        identifier: 'id',
        controller: _controller,
        itemBuilder: (_, value, ___) => ColoredBox(color: value),
        itemCount: _colors.length,
        itemProvider: ((index) => _colors[index]),
        builder: (_, itemBuilder, itemCount) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemBuilder: itemBuilder,
          itemCount: itemCount,
        ),
      ),
    );
  }

  void _onDragCompletion(DraggedDetails<String, Color> data) {
    final newColors = [..._colors] //
      ..removeAt(data.dragIndex)
      ..insert(data.targetIndex, data.dragItem);

    setState(() {
      _colors = newColors;
    });
  }
}
