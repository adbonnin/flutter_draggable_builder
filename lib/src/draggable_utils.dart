import 'dart:collection';

typedef ValueBuilder<K, V> = V Function(K key);
typedef IndexedValueBuilder<V> = ValueBuilder<int, V>;

class InfiniteIndexedMap<T> {
  InfiniteIndexedMap({
    required IndexedValueBuilder defaultValueBuilder,
    Map<int, T>? values,
    Map<int, List<T>>? inserted,
    Set<int>? removed,
  }) : _defaultValueBuilder = defaultValueBuilder {
    _values.addAll(values ?? const {});
    _inserted.addAll(inserted ?? const {});
    _removed.addAll(removed ?? const {});
  }

  final IndexedValueBuilder _defaultValueBuilder;
  final _values = <int, T>{};
  final _inserted = <int, List<T>>{};
  final _removed = SplayTreeSet<int>();

  T removeAt(int index) {
    final realIndex = _realIndex(index);
    _removed.add(realIndex);
    return _getAtRealIndex(realIndex);
  }

  T operator [](int index) {
    final realIndex = _realIndex(index);
    return _getAtRealIndex(realIndex);
  }

  void operator []=(int index, T value) {
    final realIndex = _realIndex(index);
    _values[realIndex] = value;
  }

  int _realIndex(int index) {
    var countRemoved = 0;

    for (final removed in _removed) {
      final realIndex = index + countRemoved;

      if (removed > realIndex) {
        return realIndex;
      }

      countRemoved = countRemoved + 1;
    }

    return index + countRemoved;
  }

  T _getAtRealIndex(int realIndex) {
    return _values.containsKey(realIndex) ? _values[realIndex] : _defaultValueBuilder(realIndex);
  }
}
