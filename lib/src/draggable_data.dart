import 'package:flutter/widgets.dart';
import 'package:draggable_builder/src/draggable_builder.dart';

class DraggableItemData<ID> {
  const DraggableItemData({
    required this.dragIdentifier,
    required this.dragIndex,
  });

  final ID dragIdentifier;
  final int dragIndex;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableItemData<ID> && //
        runtimeType == other.runtimeType &&
        dragIdentifier == other.dragIdentifier &&
        dragIndex == other.dragIndex;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^ //
        dragIndex.hashCode;
  }
}

class DraggableDragData<ID> extends DraggableItemData<ID> {
  const DraggableDragData({
    required super.dragIdentifier,
    required super.dragIndex,
    required this.placeholderBuilder,
  });

  final PlaceholderWidgetBuilder<ID> placeholderBuilder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableDragData<ID> && //
        runtimeType == other.runtimeType &&
        dragIdentifier == other.dragIdentifier &&
        dragIndex == other.dragIndex &&
        placeholderBuilder == other.placeholderBuilder;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^ //
        dragIndex.hashCode ^
        placeholderBuilder.hashCode;
  }
}

class DraggableDraggedData<ID> extends DraggableDragData<ID> {
  const DraggableDraggedData({
    required super.dragIdentifier,
    required super.dragIndex,
    required super.placeholderBuilder,
    required this.targetIdentifier,
    required this.targetIndex,
  });

  final ID targetIdentifier;
  final int targetIndex;

  Widget buildPlaceholder(BuildContext context) {
    return placeholderBuilder.call(context, dragIndex, targetIdentifier, targetIndex);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableDraggedData<ID> &&
        runtimeType == other.runtimeType &&
        dragIdentifier == other.dragIdentifier &&
        dragIndex == other.dragIndex &&
        placeholderBuilder == other.placeholderBuilder &&
        targetIdentifier == other.targetIdentifier &&
        targetIndex == other.targetIndex;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^
        dragIndex.hashCode ^
        placeholderBuilder.hashCode ^
        targetIdentifier.hashCode ^
        targetIndex.hashCode;
  }
}
