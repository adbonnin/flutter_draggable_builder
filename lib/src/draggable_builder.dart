import 'package:draggable_builder/src/draggable_constants.dart';
import 'package:draggable_builder/src/draggable_controller.dart';
import 'package:draggable_builder/src/draggable_data.dart';
import 'package:flutter/widgets.dart';

typedef ScrollableBuilder = Widget Function(
  BuildContext context,
  NullableIndexedWidgetBuilder itemBuilder,
  int? itemCount,
);

typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
  int dragIndex,
  Object targetId,
  int targetIndex,
);

class DraggableBuilder extends StatefulWidget {
  const DraggableBuilder({
    super.key,
    this.identifier = DraggableSpecialIdentifier.mustBeUnique,
    this.isLongPress = false,
    this.controller,
    this.axis,
    this.feedbackOffset = Offset.zero,
    this.feedbackSizeSameAsItem = true,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    required this.itemBuilder,
    this.itemWhenDraggingBuilder,
    this.feedbackBuilder,
    this.placeholderBuilder,
    this.emptyItemBuilder,
    this.itemCount,
    required this.builder,
  });

  final Object identifier;
  final bool isLongPress;
  final DraggableController? controller;
  final Axis? axis;
  final Offset feedbackOffset;
  final bool feedbackSizeSameAsItem;
  final DragAnchorStrategy dragAnchorStrategy;
  final Axis? affinity;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? itemWhenDraggingBuilder;
  final NullableIndexedWidgetBuilder? feedbackBuilder;
  final PlaceholderWidgetBuilder? placeholderBuilder;
  final WidgetBuilder? emptyItemBuilder;
  final int? itemCount;
  final ScrollableBuilder builder;

  @override
  State<DraggableBuilder> createState() => _DraggableBuilderState();
}

class _DraggableBuilderState extends State<DraggableBuilder> {
  DraggableController? _controller;

  void _updateDraggableController() {
    final newController = widget.controller ?? DefaultDraggableController.maybeOf(context);

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
  void didUpdateWidget(DraggableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _updateDraggableController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = ListenableBuilder(
      listenable: _controller!,
      builder: (context, _) => widget.builder(context, _buildItem, _itemCount),
    );

    return DragTarget<DraggableDragData>(
      onMove: (details) => _onDragTargetMove(details, null),
      builder: (_, __, ___) => child,
    );
  }

  Widget? _buildItem(BuildContext context, int index) {
    final item = _controller!.computeItem(widget.identifier, index);

    if (item is DraggableDraggedData) {
      return item.buildPlaceholder(context);
    }

    if (_shouldDisplayEmptyItem) {
      return widget.emptyItemBuilder?.call(context) ?? const SizedBox();
    }

    final IndexedWidgetBuilder itemBuilder;

    if (item.dragIdentifier == widget.identifier) {
      itemBuilder = widget.itemBuilder;
    } //
    else if (item.dragIdentifier == DraggableSpecialIdentifier.notDraggable) {
      itemBuilder = widget.itemBuilder;
    } //
    else {
      itemBuilder = widget.itemWhenDraggingBuilder ?? widget.itemBuilder;
    }

    return DragTarget<DraggableDragData>(
      onMove: (details) => _onDragTargetMove(details, index),
      builder: (_, __, ___) => LayoutBuilder(
        builder: (context, constraints) {
          var effectiveChild = itemBuilder(context, item.dragIndex);

          if (item.dragIdentifier != DraggableSpecialIdentifier.notDraggable) {
            final data = DraggableDragData(
              dragIdentifier: widget.identifier,
              dragIndex: item.dragIndex,
              placeholderBuilder: widget.placeholderBuilder ?? (c, i, ___, ____) => widget.itemBuilder(c, i),
            );

            var effectiveFeedback = widget.feedbackBuilder?.call(context, item.dragIndex) ?? effectiveChild;

            if (widget.feedbackSizeSameAsItem) {
              effectiveFeedback = SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: effectiveFeedback,
              );
            }

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
          }

          return effectiveChild;
        },
      ),
    );
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

  void _onDragTargetMove(DragTargetDetails<DraggableDragData> details, int? targetIndex) {
    _controller!.onDragTargetMove(details.data, widget.identifier, targetIndex, widget.itemCount);
  }

  void _onDragEnd(DraggableDetails details) {
    _controller!.onDragEnd(details.wasAccepted);
  }
}
