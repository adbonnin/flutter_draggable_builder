import 'package:draggable_builder/src/draggable_builder.dart';
import 'package:flutter/widgets.dart';

class TargetDetails<ID, T> {
  const TargetDetails({
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

    return other is TargetDetails<ID, T> && //
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

class DragDetails<ID, T> extends TargetDetails<ID, T> {
  const DragDetails({
    required super.dragIdentifier,
    required super.dragIndex,
    required this.dragValue,
    required this.placeholderBuilder,
  });

  final T dragValue;
  final PlaceholderWidgetBuilder<ID, T> placeholderBuilder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DragDetails<ID, T> && //
        runtimeType == other.runtimeType &&
        dragIdentifier == other.dragIdentifier &&
        dragIndex == other.dragIndex &&
        dragValue == other.dragValue &&
        placeholderBuilder == other.placeholderBuilder;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^ //
        dragIndex.hashCode ^
        dragValue.hashCode ^
        placeholderBuilder.hashCode;
  }
}

class DraggedDetails<ID, T> extends DragDetails<ID, T> {
  const DraggedDetails({
    required super.dragIdentifier,
    required super.dragIndex,
    required super.dragValue,
    required super.placeholderBuilder,
    required this.targetIdentifier,
    required this.targetIndex,
    required this.targetValue,
  });

  final ID targetIdentifier;
  final int targetIndex;
  final T? targetValue;

  Widget buildPlaceholder(BuildContext context) {
    return placeholderBuilder.call(context, this);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DraggedDetails<ID, T> &&
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
