import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class DragAnchorStrategyKnob extends Knob<DragAnchorStrategy?> {
  DragAnchorStrategyKnob({
    required super.label,
    required super.initialValue,
    super.description,
  });

  DragAnchorStrategyKnob.nullable({
    required super.label,
    required super.initialValue,
    super.description,
  }) : super(isNullable: true);

  @override
  List<Field> get fields {
    return [
      ListField<DragAnchorStrategy>(
        name: label,
        initialValue: initialValue,
        labelBuilder: buildLabel,
        values: [
          childDragAnchorStrategy,
          pointerDragAnchorStrategy,
        ],
      ),
    ];
  }

  @override
  DragAnchorStrategy? valueFromQueryGroup(Map<String, String> group) {
    return valueOf(label, group);
  }

  String buildLabel(DragAnchorStrategy strategy) {
    return switch (strategy) {
      childDragAnchorStrategy => "childDragAnchorStrategy",
      pointerDragAnchorStrategy => "pointerDragAnchorStrategy",
      _ => "",
    };
  }
}
