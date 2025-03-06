import 'package:flutter/widgets.dart';
import 'package:draggable_builder/src/draggable_builder.dart';

class DraggableItemData {
  const DraggableItemData({
    required this.dragId,
    required this.dragIndex,
  });

  final Object dragId;
  final int dragIndex;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableItemData && //
        runtimeType == other.runtimeType &&
        dragId == other.dragId &&
        dragIndex == other.dragIndex;
  }

  @override
  int get hashCode {
    return dragId.hashCode ^ //
        dragIndex.hashCode;
  }
}

class DraggableDragData extends DraggableItemData {
  const DraggableDragData({
    required super.dragId,
    required super.dragIndex,
    required this.placeholderBuilder,
  });

  final PlaceholderWidgetBuilder placeholderBuilder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableDragData && //
        runtimeType == other.runtimeType &&
        dragId == other.dragId &&
        dragIndex == other.dragIndex &&
        placeholderBuilder == other.placeholderBuilder;
  }

  @override
  int get hashCode {
    return dragId.hashCode ^ //
        dragIndex.hashCode ^
        placeholderBuilder.hashCode;
  }
}

class DraggableDraggedData extends DraggableDragData {
  const DraggableDraggedData({
    required super.dragId,
    required super.dragIndex,
    required super.placeholderBuilder,
    required this.targetId,
    required this.targetIndex,
  });

  final Object targetId;
  final int targetIndex;

  Widget buildPlaceholder(BuildContext context) {
    return placeholderBuilder.call(context, dragIndex, targetId, targetIndex);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggableDraggedData &&
        runtimeType == other.runtimeType &&
        dragId == other.dragId &&
        dragIndex == other.dragIndex &&
        placeholderBuilder == other.placeholderBuilder &&
        targetId == other.targetId &&
        targetIndex == other.targetIndex;
  }

  @override
  int get hashCode {
    return dragId.hashCode ^
        dragIndex.hashCode ^
        placeholderBuilder.hashCode ^
        targetId.hashCode ^
        targetIndex.hashCode;
  }
}
