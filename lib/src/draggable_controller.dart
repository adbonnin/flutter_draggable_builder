import 'package:draggable_builder/src/draggable_data.dart';
import 'package:draggable_builder/src/draggable_utils.dart';
import 'package:flutter/widgets.dart';

typedef DragCompletionCallback<ID, T> = void Function(DraggedDetails<ID, T> dragged);

class DraggableController<ID, T> with ChangeNotifier {
  DraggableController({
    this.onDragCompletion,
  });

  DragCompletionCallback<ID, T>? onDragCompletion;

  DraggedDetails<ID, T>? _data;

  DraggedDetails<ID, T>? get data => _data;

  int? computeItemCount(ID id, int? itemCount) {
    return _data?.computeItemCount(id, itemCount) ?? itemCount;
  }

  TargetDetails<ID, T> computeItem(ID id, int index) {
    final effectiveIndex = _data?.computeEffectiveIndex(id, index) ?? index;

    if (effectiveIndex < 0) {
      return _data!;
    }

    final effectiveId = _data?.computeEffectiveId(id, index) ?? id;
    return TargetDetails(dragIdentifier: effectiveId, dragIndex: effectiveIndex);
  }

  @visibleForTesting
  static int computeDragIndex(int index, int targetIndex, int draggedIndex) {
    // Move backward
    if (draggedIndex > targetIndex) {
      if (targetIndex < index && index <= draggedIndex) {
        return index - 1;
      }
    }
    // Move forward
    else if (draggedIndex < targetIndex) {
      if (draggedIndex <= index && index < targetIndex) {
        return index + 1;
      }
    }

    return index;
  }

  void onDragTargetMove(
    DragDetails<ID, T> drag,
    ID targetIdentifier,
    int? targetIndex,
    int? targetCount,
    IndexedValueProvider targetValueProvider,
  ) {
    final isSameDrag = _data?.dragIdentifier == drag.dragIdentifier && //
        _data?.dragIndex == drag.dragIndex &&
        _data?.targetIdentifier == targetIdentifier;

    if (targetIndex == null) {
      if (isSameDrag) {
        return;
      }

      targetIndex = targetCount ?? 0;
    }

    if (isSameDrag && _data?.targetIndex == targetIndex) {
      return;
    }

    final targetValue = targetCount != null && targetIndex >= targetCount ? null : targetValueProvider(targetIndex);

    final data = DraggedDetails<ID, T>(
      dragIdentifier: drag.dragIdentifier,
      dragIndex: drag.dragIndex,
      dragValue: drag.dragValue,
      placeholderBuilder: drag.placeholderBuilder,
      targetIdentifier: targetIdentifier,
      targetIndex: targetIndex,
      targetValue: targetValue,
    );

    _data = data;
    notifyListeners();
  }

  void onDragEnd() {
    if (_data is DraggedDetails<ID, T>) {
      onDragCompletion?.call(_data!);
    }

    _data = null;
    notifyListeners();
  }
}

extension _DraggableDraggedDataExtension<ID, T> on DraggedDetails<ID, T> {
  int? computeItemCount(ID id, int? itemCount) {
    if (itemCount == null || !itemCount.isFinite) {
      return itemCount;
    }

    if (dragIdentifier != targetIdentifier) {
      // if (id == dragId) {
      //   return itemCount - 1;
      // }

      if (id == targetIdentifier) {
        return itemCount + 1;
      }
    }

    return itemCount;
  }

  int computeEffectiveIndex(ID id, int index) {
    if (dragIdentifier != targetIdentifier) {
      // if (id == dragId) {
      //   return index >= dragIndex ? index + 1 : index;
      // }

      if (id == targetIdentifier) {
        if (index == targetIndex) {
          return -1;
        }

        return index >= targetIndex ? index - 1 : index;
      }
    } //
    else {
      if (id == dragIdentifier) {
        if (index == targetIndex && (targetIndex != dragIndex)) {
          return -1;
        }

        return DraggableController.computeDragIndex(index, targetIndex, dragIndex);
      }
    }

    return index;
  }

  ID computeEffectiveId(ID id, int index) {
    return id == dragIdentifier && index == dragIndex ? targetIdentifier : id;
  }
}

class DefaultDraggableController<ID, T> extends StatefulWidget {
  const DefaultDraggableController({
    super.key,
    required this.controller,
    required this.child,
  });

  final DraggableController<ID, T> controller;
  final Widget? child;

  static TransitionBuilder builder<ID, T>({
    required DraggableController<ID, T> controller,
    TransitionBuilder? builder,
  }) {
    return (context, child) {
      child = DefaultDraggableController<ID, T>(controller: controller, child: child);
      return builder == null ? child : builder(context, child);
    };
  }

  static DraggableController<ID, T>? maybeOf<ID, T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_DraggableControllerScope<ID, T>>()?.controller;
  }

  @override
  State<DefaultDraggableController<ID, T>> createState() => _DefaultDraggableControllerState<ID, T>();
}

class _DefaultDraggableControllerState<ID, T> extends State<DefaultDraggableController<ID, T>> {
  @override
  Widget build(BuildContext context) {
    return _DraggableControllerScope<ID, T>(
      controller: widget.controller,
      child: widget.child ?? const SizedBox(),
    );
  }
}

class _DraggableControllerScope<ID, T> extends InheritedWidget {
  const _DraggableControllerScope({
    required this.controller,
    required super.child,
  });

  final DraggableController<ID, T> controller;

  @override
  bool updateShouldNotify(_DraggableControllerScope<ID, T> old) {
    return controller != old.controller;
  }
}
