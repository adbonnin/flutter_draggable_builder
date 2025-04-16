import 'package:flutter/painting.dart';
import 'package:widgetbook/widgetbook.dart';

class AxisKnob extends Knob<Axis?> {
  AxisKnob({
    required super.label,
    required super.initialValue,
    super.description,
  });

  AxisKnob.nullable({
    required super.label,
    required super.initialValue,
    super.description,
  }) : super(isNullable: true);

  @override
  List<Field> get fields {
    return [
      ListField<Axis>(
        name: label,
        initialValue: initialValue,
        values: Axis.values,
      ),
    ];
  }

  @override
  Axis? valueFromQueryGroup(Map<String, String> group) {
    return valueOf(label, group);
  }
}
