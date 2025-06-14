import 'package:flutter/widgets.dart';
import 'package:draggable_builder/src/draggable_constants.dart';
import 'package:draggable_builder/src/draggable_data.dart';

typedef DragCompletionCallback = void Function(Object dragId, int dragIndex, Object targetId, int targetIndex);

class DraggableController with ChangeNotifier {
  DraggableController({
    this.onDragCompletion,
  });

  DragCompletionCallback? onDragCompletion;

  DraggableDraggedData? _data;

  int? computeItemCount(Object id, int? itemCount) {
    return _data?.computeItemCount(id, itemCount) ?? itemCount;
  }

  DraggableItemData computeItem(Object id, int index) {
    final effectiveIndex = _data?.computeEffectiveIndex(id, index) ?? index;

    if (effectiveIndex < 0) {
      return _data!;
    }

    final effectiveId = _data?.computeEffectiveId(id, index) ?? id;
    return DraggableItemData(dragIdentifier: effectiveId, dragIndex: effectiveIndex);
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

  void onDragTargetMove(DraggableDragData drag, Object targetIdentifier, int? targetIndex, int? targetCount) {
    if (targetIndex == null) {
      if (drag.dragIdentifier == targetIdentifier) {
        return;
      }

      final isSameDrag = _data?.dragIdentifier == drag.dragIdentifier && //
          _data?.dragIndex == drag.dragIndex &&
          _data?.targetIdentifier == targetIdentifier;

      if (isSameDrag) {
        return;
      }

      targetIndex = targetCount ?? 0;
    }

    final data = DraggableDraggedData(
      dragIdentifier: drag.dragIdentifier,
      dragIndex: drag.dragIndex,
      placeholderBuilder: drag.placeholderBuilder,
      targetIdentifier: targetIdentifier,
      targetIndex: targetIndex,
    );

    if (_data == data) {
      return;
    }

    _data = data;
    notifyListeners();
  }

  void onDragEnd() {
    if (_data is DraggableDraggedData) {
      onDragCompletion?.callWithData(_data!);
    }

    _data = null;
    notifyListeners();
  }
}

extension _DraggableDraggedDataExtension on DraggableDraggedData {
  int? computeItemCount(Object id, int? itemCount) {
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

  int computeEffectiveIndex(Object id, int index) {
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

  Object computeEffectiveId(Object id, int index) {
    return id == dragIdentifier && index == dragIndex ? targetIdentifier : DraggableSpecialIdentifier.notDraggable;
  }
}

extension _DragCompletionCallbackExtension on DragCompletionCallback {
  void callWithData(DraggableDraggedData data) {
    return call(data.dragIdentifier, data.dragIndex, data.targetIdentifier, data.targetIndex);
  }
}

class DefaultDraggableController extends StatefulWidget {
  const DefaultDraggableController({
    super.key,
    required this.controller,
    required this.child,
  });

  final DraggableController controller;
  final Widget? child;

  static TransitionBuilder builder({
    required DraggableController controller,
    TransitionBuilder? builder,
  }) {
    return (context, child) {
      child = DefaultDraggableController(controller: controller, child: child);
      return builder == null ? child : builder(context, child);
    };
  }

  static DraggableController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_DraggableControllerScope>()?.controller;
  }

  @override
  State<DefaultDraggableController> createState() => _DefaultDraggableControllerState();
}

class _DefaultDraggableControllerState extends State<DefaultDraggableController> {
  @override
  Widget build(BuildContext context) {
    return _DraggableControllerScope(
      controller: widget.controller,
      child: widget.child ?? const SizedBox(),
    );
  }
}

class _DraggableControllerScope extends InheritedWidget {
  const _DraggableControllerScope({
    required this.controller,
    required super.child,
  });

  final DraggableController controller;

  @override
  bool updateShouldNotify(_DraggableControllerScope old) {
    return controller != old.controller;
  }
}
