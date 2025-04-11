import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/models/item.dart';
import 'package:widgetbook_workspace/widgets/item_box.dart';
import 'package:draggable_builder/draggable_builder.dart';

final rgbColors = [Colors.red, Colors.green, Colors.blue, Colors.white];
final cmyColors = [Colors.cyan, Colors.pink, Colors.yellow, Colors.black];

IndexedValueProvider<Item> buildDefaultValueProvider(List<Color> colors) {
  return (index) {
    return Item(
      index: index,
      color: colors[index % colors.length],
    );
  };
}

Widget itemBuilder(BuildContext context, Item item) {
  return ItemBox(
    color: item.color,
    index: item.index,
  );
}

extension ColorListExtension on List<Color> {
  List<Item> toItems() {
    final list = <Item>[];

    for (var i = 0; i < length; i++) {
      list.add(Item(index: i, color: this[i]));
    }

    return list;
  }
}

extension KnobsBuilderExtension on KnobsBuilder {
  WidgetBuilder? emptyItemBuilder() {
    return booleanValue(
      label: 'use empty item builder',
      initialValue: true,
      onTrue: (_) => ItemBox(
        color: Colors.grey,
        label: 'Empty',
      ),
      onFalse: null,
    );
  }

  Widget Function(BuildContext, Item)? itemWhenDraggingBuilder() {
    return booleanValue(
      label: 'use item when dragging builder',
      initialValue: true,
      onTrue: (_, item) => ItemBox(
        color: item.color.withAlpha(128),
        index: item.index,
        label: 'When\nDragging',
      ),
      onFalse: null,
    );
  }

  Widget Function(BuildContext, Item)? feedbackBuilder() {
    return booleanValue(
      label: 'use feedback builder',
      initialValue: true,
      onTrue: (_, item) => ItemBox(
        color: item.color.withAlpha(128),
        index: item.index,
        label: 'Feedback',
      ),
      onFalse: null,
    );
  }

  bool feedbackConstraintsSameAsItem() {
    return boolean(
      label: 'feedback constraints same as item',
      initialValue: true,
    );
  }

  Widget Function(BuildContext, Item)? placeholderBuilder() {
    return booleanValue(
      label: 'use placeholder builder',
      initialValue: true,
      onTrue: (_, item) => ItemBox(
        color: item.color,
        index: item.index,
        label: 'Placeholder',
      ),
      onFalse: null,
    );
  }

  T booleanValue<T>({
    required String label,
    String? description,
    bool initialValue = false,
    required T onTrue,
    required T onFalse,
  }) {
    final value = boolean(
      label: label,
      description: description,
      initialValue: initialValue,
    );

    return value ? onTrue : onFalse;
  }
}
