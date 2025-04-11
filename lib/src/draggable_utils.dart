typedef IndexedValueProvider<T> = T Function(int index);

class InfiniteIndexedValueProvider<T> {
  InfiniteIndexedValueProvider(this.defaultValueProvider);

  final IndexedValueProvider<T> defaultValueProvider;
  final List<_ValueChange<T>> _changes = [];

  T call(int index) => this[index];

  T operator [](int index) {
    final changeAt = _changeAt(index);
    return changeAt.value.valueOr(defaultValueProvider);
  }

  void operator []=(int index, T newValue) {
    final changeAt = _changeAt(index);
    changeAt.value.applySet(_changes, changeAt.key, newValue);
  }

  void insertAt(int index, T newValue) {
    final changeAt = _changeAt(index, includeRemove: true);
    changeAt.value.applyInsert(_changes, changeAt.key, newValue);
  }

  T removeAt(int index) {
    final changeAt = _changeAt(index);
    changeAt.value.applyRemove(_changes, changeAt.key);
    return changeAt.value.valueOr(defaultValueProvider);
  }

  MapEntry<int, _ValueChange<T>> _changeAt(int index, {bool includeRemove = false}) {
    var realIndex = index;
    int i = 0;

    for (; i < _changes.length; i++) {
      final change = _changes[i];

      if (change.index > realIndex) {
        break;
      }

      if (change.index == realIndex) {
        final mustReturn = includeRemove || change is! _RemoveChange<T>;

        if (mustReturn) {
          return MapEntry(i, change);
        }
      }

      if (change is _InsertChange<T>) {
        realIndex = realIndex - 1;
      } //
      else if (change is _RemoveChange<T>) {
        realIndex = realIndex + 1;
      }
    }

    return MapEntry(i, _NoChange<T>(realIndex));
  }
}

abstract class _ValueChange<T> {
  const _ValueChange(this.index);

  final int index;

  T valueOr(IndexedValueProvider<T> valueProvider) {
    return valueProvider(index);
  }

  void applySet(List<_ValueChange<T>> changes, int changeIndex, T newValue);

  void applyInsert(List<_ValueChange<T>> changes, int changeIndex, T newValue);

  void applyRemove(List<_ValueChange<T>> changes, int changeIndex);
}

class _NoChange<T> extends _ValueChange<T> {
  const _NoChange(super.index);

  @override
  void applySet(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes.insert(changeIndex, _SetChange<T>(index, newValue));
  }

  @override
  void applyInsert(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes.insert(changeIndex, _InsertChange<T>(index, newValue));
  }

  @override
  void applyRemove(List<_ValueChange<T>> changes, int changeIndex) {
    changes.insert(changeIndex, _RemoveChange<T>(index));
  }
}

class _SetChange<T> extends _ValueChange<T> {
  const _SetChange(super.index, this.value);

  final T value;

  @override
  T valueOr(IndexedValueProvider<T> valueProvider) => value;

  @override
  void applySet(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes[changeIndex] = _SetChange<T>(index, newValue);
  }

  @override
  void applyInsert(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes.insert(changeIndex, _InsertChange<T>(index, newValue));
  }

  @override
  void applyRemove(List<_ValueChange<T>> changes, int changeIndex) {
    changes[changeIndex] = _RemoveChange<T>(index);
  }
}

class _InsertChange<T> extends _ValueChange<T> {
  const _InsertChange(super.index, this.value);

  final T value;

  @override
  T valueOr(IndexedValueProvider<T> valueProvider) => value;

  @override
  void applySet(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes[changeIndex] = _InsertChange<T>(index, newValue);
  }

  @override
  void applyInsert(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes.insert(changeIndex, _InsertChange<T>(index, newValue));
  }

  @override
  void applyRemove(List<_ValueChange<T>> changes, int changeIndex) {
    changes.removeAt(changeIndex);
  }
}

class _RemoveChange<T> extends _ValueChange<T> {
  const _RemoveChange(super.index);

  @override
  T valueOr(IndexedValueProvider<T> valueProvider) {
    throw UnsupportedError('Cannot retrieve a value from a removed index (index: $index).');
  }

  @override
  void applySet(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    throw UnsupportedError('Cannot set a value on a removed index (index: $index).');
  }

  @override
  void applyInsert(List<_ValueChange<T>> changes, int changeIndex, T newValue) {
    changes[changeIndex] = _SetChange(index, newValue);
  }

  @override
  void applyRemove(List<_ValueChange<T>> changes, int changeIndex) {
    throw UnsupportedError('Cannot remove an index that has already been removed (index: $index).');
  }
}
