import 'package:draggable_builder/src/draggable_builder.dart';
import 'package:flutter/widgets.dart';

typedef ItemProvider<T> = T Function(int index);

@immutable
class TargetDetails<ID, T> {
  const TargetDetails({
    required this.dragIdentifier,
    required this.dragIndex,
  });

  final ID dragIdentifier;
  final int dragIndex;

  TargetDetails<ID, T> copyWith({
    ID? dragIdentifier,
    int? dragIndex,
  }) {
    return TargetDetails<ID, T>(
      dragIdentifier: dragIdentifier ?? this.dragIdentifier,
      dragIndex: dragIndex ?? this.dragIndex,
    );
  }

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

@immutable
class DragDetails<ID, T> extends TargetDetails<ID, T> {
  const DragDetails({
    required super.dragIdentifier,
    required super.dragIndex,
    required this.dragItem,
    required this.placeholderBuilder,
  });

  final T dragItem;
  final PlaceholderWidgetBuilder<ID, T> placeholderBuilder;

  @override
  DragDetails<ID, T> copyWith({
    ID? dragIdentifier,
    int? dragIndex,
    T? dragItem,
    PlaceholderWidgetBuilder<ID, T>? placeholderBuilder,
  }) {
    return DragDetails<ID, T>(
      dragIdentifier: dragIdentifier ?? this.dragIdentifier,
      dragIndex: dragIndex ?? this.dragIndex,
      dragItem: dragItem ?? this.dragItem,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DragDetails<ID, T> && //
        runtimeType == other.runtimeType &&
        dragIdentifier == other.dragIdentifier &&
        dragIndex == other.dragIndex &&
        dragItem == other.dragItem &&
        placeholderBuilder == other.placeholderBuilder;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^ //
        dragIndex.hashCode ^
        dragItem.hashCode ^
        placeholderBuilder.hashCode;
  }
}

class DraggedDetails<ID, T> extends DragDetails<ID, T> {
  const DraggedDetails({
    required super.dragIdentifier,
    required super.dragIndex,
    required super.dragItem,
    required super.placeholderBuilder,
    required this.targetIdentifier,
    required this.targetIndex,
    required this.targetItem,
  });

  final ID targetIdentifier;
  final int targetIndex;
  final T? targetItem;

  Widget buildPlaceholder(BuildContext context) {
    return placeholderBuilder(context, this);
  }

  @override
  DraggedDetails<ID, T> copyWith({
    ID? dragIdentifier,
    int? dragIndex,
    T? dragItem,
    PlaceholderWidgetBuilder<ID, T>? placeholderBuilder,
    ID? targetIdentifier,
    int? targetIndex,
    T? targetItem,
  }) {
    return DraggedDetails<ID, T>(
      dragIdentifier: dragIdentifier ?? this.dragIdentifier,
      dragIndex: dragIndex ?? this.dragIndex,
      dragItem: dragItem ?? this.dragItem,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      targetIdentifier: targetIdentifier ?? this.targetIdentifier,
      targetIndex: targetIndex ?? this.targetIndex,
      targetItem: targetItem ?? this.targetItem,
    );
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
        targetIndex == other.targetIndex &&
        targetItem == other.targetItem;
  }

  @override
  int get hashCode {
    return dragIdentifier.hashCode ^
        dragIndex.hashCode ^
        placeholderBuilder.hashCode ^
        targetIdentifier.hashCode ^
        targetIndex.hashCode ^
        targetItem.hashCode;
  }
}
