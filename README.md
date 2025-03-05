# Draggable Builder

Add draggable item support to dynamically built scrollable containers like GridView and ListView in
Flutter.

[![Pub](https://img.shields.io/pub/v/draggable_builder.svg)](https://pub.dartlang.org/packages/draggable_builder)

## Getting started

In your library add the following import:

```dart
import 'package:draggable_builder/draggable_builder.dart';
```

Add a `DraggableController` property to the `State` of your `StatefulWidget` and initialize it with
an `onDragCompletion` callback, which will be triggered when a drag action is completed. Remember to
properly dispose of the `DraggableController` to prevent memory leaks.

To integrate the `DraggableBuilder` with your scrollable widget, such as `GridView.builder` or
`ListView.builder`, follow these steps:

1. Wrap your scrollable widget with a `DraggableBuilder`, passing the previous controller through
   the `controller` property.
2. Provide the `itemBuilder` property to define how the items in the scrollable are built, and
   optionally specify the `itemCount` property to represent the total number of items.
3. Within the `builder` property, create your scrollable widget and delegate the `itemBuilder` and
   `itemCount` properties to those passed as parameters.

Here’s a simple example:

```dart
```

