import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/widgets/grid_item.dart';

extension KnobsBuilderExtension on KnobsBuilder {
  WidgetBuilder? emptyItemBuilder() {
    return booleanValue(
      label: 'use empty item builder',
      initialValue: true,
      onTrue: (_) => GridItem(
        color: Colors.grey,
        text: 'Empty',
      ),
      onFalse: null,
    );
  }

  Widget Function(BuildContext, Color)? itemWhenDraggingBuilder() {
    return booleanValue(
      label: 'use item when dragging builder',
      initialValue: true,
      onTrue: (_, color) => GridItem(
        color: color.withAlpha(128),
        text: 'When\nDragging',
      ),
      onFalse: null,
    );
  }

  Widget Function(BuildContext, Color)? feedbackBuilder() {
    return booleanValue(
      label: 'use feedback builder',
      initialValue: true,
      onTrue: (_, color) => GridItem(
        color: color.withAlpha(128),
        text: 'Feedback',
      ),
      onFalse: null,
    );
  }

  Widget Function(BuildContext, Color)? placeholderBuilder() {
    return booleanValue(
      label: 'use placeholder builder',
      initialValue: true,
      onTrue: (_, color) => GridItem(
        color: color,
        text: 'Placeholder',
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
