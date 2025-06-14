import 'package:draggable_builder/src/draggable_controller.dart';
import 'package:draggable_builder/src/draggable_data.dart';
import 'package:draggable_builder/src/draggable_utils.dart';
import 'package:flutter/widgets.dart';

typedef ContainerBuilder = Widget Function(
  BuildContext context,
  NullableIndexedWidgetBuilder itemBuilder,
  int? itemCount,
);

typedef PlaceholderWidgetBuilder<ID, T> = Widget Function(
  BuildContext context,
  DraggedDetails dragged,
);

class DraggableBuilder<ID, T> extends StatefulWidget {
  const DraggableBuilder({
    super.key,
    required this.identifier,
    this.isLongPress = false,
    this.controller,
    this.axis,
    this.feedbackOffset = Offset.zero,
    this.feedbackConstraintsSameAsItem = true,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    this.wrapWithDragTarget = false,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.feedbackBuilder,
    this.placeholderBuilder,
    this.emptyItemBuilder,
    this.itemCount,
    required this.valueProvider,
    required this.builder,
  });

  final ID identifier;
  final bool isLongPress;
  final DraggableController<ID, T>? controller;
  final Axis? axis;
  final Offset feedbackOffset;
  final bool feedbackConstraintsSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
  final bool wrapWithDragTarget;
  final IndexedValueWidgetBuilder<T> itemBuilder;
  final IndexedValueWidgetBuilder<T>? itemWhenDraggingBuilder;
  final NullableIndexedValueWidgetBuilder<T>? feedbackBuilder;
  final PlaceholderWidgetBuilder<ID, T>? placeholderBuilder;
  final WidgetBuilder? emptyItemBuilder;
  final int? itemCount;
  final IndexedValueProvider<T> valueProvider;
  final ContainerBuilder builder;

  @override
  State<DraggableBuilder<ID, T>> createState() => _DraggableBuilderState<ID, T>();
}

class _DraggableBuilderState<ID, T> extends State<DraggableBuilder<ID, T>> {
  DraggableController<ID, T>? _controller;

  void _updateDraggableController() {
    final newController = widget.controller ?? DefaultDraggableController.maybeOf<ID, T>(context);

    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No DraggableController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'DraggableController using the "controller" property, or you must ensure that there '
          'is a DefaultDraggableController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    _controller = newController;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDraggableController();
  }

  @override
  void didUpdateWidget(DraggableBuilder<ID, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _updateDraggableController();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget effectiveChild = ListenableBuilder(
      listenable: _controller!,
      builder: (context, _) => widget.builder(context, _buildItem, _itemCount),
    );

    if (widget.wrapWithDragTarget) {
      final child = effectiveChild;

      effectiveChild = DragTarget<DragDetails<ID, T>>(
        onMove: (details) => _onDragTargetMove(details, null, null),
        builder: (_, __, ___) => child,
      );
    }

    return effectiveChild;
  }

  Widget? _buildItem(BuildContext context, int index) {
    final item = _controller!.computeItem(widget.identifier, index);

    if (item is DraggedDetails<ID, T>) {
      return item.buildPlaceholder(context);
    }

    T? dragValue;
    DragTargetBuilder<DragDetails<ID, T>> itemBuilder;

    if (_shouldDisplayEmptyItem) {
      dragValue = null;
      itemBuilder = (context, __, ___) => widget.emptyItemBuilder?.call(context) ?? const SizedBox();
    } //
    else if (!widget.feedbackConstraintsSameAsItem) {
      dragValue = widget.valueProvider(item.dragIndex);
      itemBuilder = (context, __, ___) => _buildDraggable(context, item, dragValue as T);
    } //
    else {
      dragValue = widget.valueProvider(item.dragIndex);
      itemBuilder = (_, __, ___) => LayoutBuilder(
            builder: (context, constraints) => _buildDraggable(context, item, dragValue as T, constraints),
          );
    }

    return DragTarget<DragDetails<ID, T>>(
      onMove: (details) => _onDragTargetMove(details, index, dragValue),
      builder: itemBuilder,
    );
  }

  Widget _buildDraggable(
    BuildContext context,
    TargetDetails<ID, T> item,
    T dragValue, [
    BoxConstraints? constraints,
  ]) {
    final IndexedValueWidgetBuilder<T> itemBuilder;

    if (item.dragIdentifier == widget.identifier) {
      itemBuilder = widget.itemBuilder;
    } //
    else {
      itemBuilder = widget.itemWhenDraggingBuilder ?? widget.itemBuilder;
    }

    var effectiveChild = itemBuilder(context, item.dragIndex, dragValue);
    var effectiveFeedback = widget.feedbackBuilder?.call(context, item.dragIndex, dragValue) ?? effectiveChild;

    if (constraints != null) {
      effectiveFeedback = ConstrainedBox(
        constraints: constraints,
        child: effectiveFeedback,
      );
    }

    final data = DragDetails<ID, T>(
      dragIdentifier: widget.identifier,
      dragIndex: item.dragIndex,
      dragValue: dragValue,
      placeholderBuilder: widget.placeholderBuilder ?? (c, d) => widget.itemBuilder(c, d.dragIndex, d.dragValue),
    );

    if (widget.isLongPress) {
      effectiveChild = LongPressDraggable<DragDetails>(
        data: data,
        axis: widget.axis,
        feedbackOffset: widget.feedbackOffset,
        dragAnchorStrategy: widget.dragAnchorStrategy,
        maxSimultaneousDrags: 1,
        onDragEnd: _onDragEnd,
        feedback: effectiveFeedback,
        child: effectiveChild,
      );
    } //
    else {
      effectiveChild = Draggable<DragDetails>(
        data: data,
        axis: widget.axis,
        feedbackOffset: widget.feedbackOffset,
        dragAnchorStrategy: widget.dragAnchorStrategy,
        affinity: widget.affinity,
        maxSimultaneousDrags: 1,
        onDragEnd: _onDragEnd,
        feedback: effectiveFeedback,
        child: effectiveChild,
      );
    }

    return effectiveChild;
  }

  bool get _shouldDisplayEmptyItem {
    return widget.itemCount != null && widget.itemCount! <= 0;
  }

  int? get _itemCount {
    if (_shouldDisplayEmptyItem) {
      return 1;
    }

    return _controller!.computeItemCount(widget.identifier, widget.itemCount);
  }

  void _onDragTargetMove(DragTargetDetails<DragDetails<ID, T>> details, int? targetIndex, T? targetValue) {
    _controller!.onDragTargetMove(details.data, widget.identifier, targetIndex, targetValue, widget.itemCount);
  }

  void _onDragEnd(DraggableDetails details) {
    _controller!.onDragEnd();
  }
}
