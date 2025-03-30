import 'package:flutter/cupertino.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/widgets/empty_box.dart';

extension KnobsBuilderExtension on KnobsBuilder {
  WidgetBuilder? emptyItemBuilder() {
    return booleanValue(
      label: 'empty item builder',
      initialValue: true,
      onTrue: (_) => EmptyBox(),
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
