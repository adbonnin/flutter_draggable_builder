import 'package:draggable_builder/src/draggable_data.dart';
import 'package:flutter/widgets.dart';

typedef DragCompletionCallback<ID> = void Function(ID dragId, int dragIndex, ID targetId, int targetIndex);

class DraggableController<ID> with ChangeNotifier {
  DraggableController({
    this.onDragCompletion,
  });

  DragCompletionCallback<ID>? onDragCompletion;

  DraggableDraggedData<ID>? _data;

  int? computeItemCount(ID id, int? itemCount) {
    return _data?.computeItemCount(id, itemCount) ?? itemCount;
  }

  DraggableItemData<ID> computeItem(ID id, int index) {
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

  void onDragTargetMove(DraggableDragData<ID> drag, ID targetIdentifier, int? targetIndex, int? targetCount) {
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

    final data = DraggableDraggedData<ID>(
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
    if (_data is DraggableDraggedData<ID>) {
      onDragCompletion?.callWithData(_data!);
    }

    _data = null;
    notifyListeners();
  }
}

extension _DraggableDraggedDataExtension<ID> on DraggableDraggedData<ID> {
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

extension _DragCompletionCallbackExtension<ID> on DragCompletionCallback<ID> {
  void callWithData(DraggableDraggedData<ID> data) {
    return call(data.dragIdentifier, data.dragIndex, data.targetIdentifier, data.targetIndex);
  }
}

class DefaultDraggableController<ID> extends StatefulWidget {
  const DefaultDraggableController({
    super.key,
    required this.controller,
    required this.child,
  });

  final DraggableController<ID> controller;
  final Widget? child;

  static TransitionBuilder builder<ID>({
    required DraggableController<ID> controller,
    TransitionBuilder? builder,
  }) {
    return (context, child) {
      child = DefaultDraggableController<ID>(controller: controller, child: child);
      return builder == null ? child : builder(context, child);
    };
  }

  static DraggableController<ID>? maybeOf<ID>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_DraggableControllerScope<ID>>()?.controller;
  }

  @override
  State<DefaultDraggableController<ID>> createState() => _DefaultDraggableControllerState<ID>();
}

class _DefaultDraggableControllerState<ID> extends State<DefaultDraggableController<ID>> {
  @override
  Widget build(BuildContext context) {
    return _DraggableControllerScope<ID>(
      controller: widget.controller,
      child: widget.child ?? const SizedBox(),
    );
  }
}

class _DraggableControllerScope<ID> extends InheritedWidget {
  const _DraggableControllerScope({
    required this.controller,
    required super.child,
  });

  final DraggableController<ID> controller;

  @override
  bool updateShouldNotify(_DraggableControllerScope<ID> old) {
    return controller != old.controller;
  }
}
