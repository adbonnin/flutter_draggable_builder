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
    return Scaffold(
      body: DraggableBuilder(
        controller: _controller,
        itemBuilder: (_, index) => ColoredBox(color: _colors[index]),
        itemCount: _colors.length,
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

  void _onDragCompletion(Object dragId, int dragIndex, Object targetId, int targetIndex) {
    final newColors = [..._colors] //
      ..removeAt(dragIndex)
      ..insert(targetIndex, _colors[dragIndex]);

    setState(() {
      _colors = newColors;
    });
  }
}
