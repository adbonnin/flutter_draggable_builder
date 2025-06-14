import 'package:draggable_builder/src/draggable_controller.dart';
import 'package:draggable_builder/src/draggable_data.dart';
import 'package:flutter/widgets.dart';

typedef ScrollableBuilder = Widget Function(
  BuildContext context,
  NullableIndexedWidgetBuilder itemBuilder,
  int? itemCount,
);

typedef PlaceholderWidgetBuilder<ID> = Widget Function(
  BuildContext context,
  int dragIndex,
  ID targetId,
  int targetIndex,
);

class DraggableBuilder<ID> extends StatefulWidget {
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
    required this.builder,
  });

  final ID identifier;
  final bool isLongPress;
  final DraggableController<ID>? controller;
  final Axis? axis;
  final Offset feedbackOffset;
  final bool feedbackConstraintsSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
  final bool wrapWithDragTarget;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? itemWhenDraggingBuilder;
  final NullableIndexedWidgetBuilder? feedbackBuilder;
  final PlaceholderWidgetBuilder? placeholderBuilder;
  final WidgetBuilder? emptyItemBuilder;
  final int? itemCount;
  final ScrollableBuilder builder;

  @override
  State<DraggableBuilder<ID>> createState() => _DraggableBuilderState<ID>();
}

class _DraggableBuilderState<ID> extends State<DraggableBuilder<ID>> {
  DraggableController<ID>? _controller;

  void _updateDraggableController() {
    final newController = widget.controller ?? DefaultDraggableController.maybeOf<ID>(context);

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
  void didUpdateWidget(DraggableBuilder<ID> oldWidget) {
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

      effectiveChild = DragTarget<DraggableDragData<ID>>(
        onMove: (details) => _onDragTargetMove(details, null),
        builder: (_, __, ___) => child,
      );
    }

    return effectiveChild;
  }

  Widget? _buildItem(BuildContext context, int index) {
    final item = _controller!.computeItem(widget.identifier, index);

    if (item is DraggableDraggedData<ID>) {
      return item.buildPlaceholder(context);
    }

    DragTargetBuilder<DraggableDragData<ID>> itemBuilder;

    if (_shouldDisplayEmptyItem) {
      itemBuilder = (context, __, ___) => widget.emptyItemBuilder?.call(context) ?? const SizedBox();
    } //
    else if (!widget.feedbackConstraintsSameAsItem) {
      itemBuilder = (context, __, ___) => _buildDraggable(context, item);
    } //
    else {
      itemBuilder = (_, __, ___) => LayoutBuilder(
        builder: (context, constraints) => _buildDraggable(context, item, constraints),
      );
    }

    return DragTarget<DraggableDragData<ID>>(
      onMove: (details) => _onDragTargetMove(details, index),
      builder: itemBuilder,
    );
  }

  Widget _buildDraggable(BuildContext context, DraggableItemData<ID> item, [BoxConstraints? constraints]) {
    final IndexedWidgetBuilder itemBuilder;

    if (item.dragIdentifier == widget.identifier) {
      itemBuilder = widget.itemBuilder;
    } //
    else {
      itemBuilder = widget.itemWhenDraggingBuilder ?? widget.itemBuilder;
    }

    var effectiveChild = itemBuilder(context, item.dragIndex);
    var effectiveFeedback = widget.feedbackBuilder?.call(context, item.dragIndex) ?? effectiveChild;

    if (constraints != null) {
      effectiveFeedback = ConstrainedBox(
        constraints: constraints,
        child: effectiveFeedback,
      );
    }

    final data = DraggableDragData<ID>(
      dragIdentifier: widget.identifier,
      dragIndex: item.dragIndex,
      placeholderBuilder: widget.placeholderBuilder ?? (c, i, ___, ____) => widget.itemBuilder(c, i),
    );

    if (widget.isLongPress) {
      effectiveChild = LongPressDraggable<DraggableDragData>(
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
      effectiveChild = Draggable<DraggableDragData>(
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

  void _onDragTargetMove(DragTargetDetails<DraggableDragData<ID>> details, int? targetIndex) {
    _controller!.onDragTargetMove(details.data, widget.identifier, targetIndex, widget.itemCount);
  }

  void _onDragEnd(DraggableDetails details) {
    _controller!.onDragEnd();
  }
}
