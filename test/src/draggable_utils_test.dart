import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int indexToValueBuilder(index) => index;

  test("should return the index", () {
    // given:
    final map = InfiniteIndexedMap(defaultValueBuilder: indexToValueBuilder);

    // expect:
    expect(map[5], 5);
  });

  test("should remove one value", () {
    // given:
    final map = InfiniteIndexedMap(defaultValueBuilder: indexToValueBuilder);

    // when:
    map.removeAt(5);

    // then:
    expect(map[4], 4);
    expect(map[5], 6);
  });

  test("should remove multiple values with highest value first", () {
    // given:
    final map = InfiniteIndexedMap(defaultValueBuilder: indexToValueBuilder);

    // when:
    map.removeAt(6);
    map.removeAt(3);

    // then:
    expect(map[2], 2);
    expect(map[3], 4);

    expect(map[5], 7);
    expect(map[6], 8);
  });

  test("should remove multiple values with lowest value first", () {
    // given:
    final map = InfiniteIndexedMap(defaultValueBuilder: indexToValueBuilder);

    // when:
    map.removeAt(3);
    map.removeAt(6);

    // then:
    expect(map[2], 2);
    expect(map[3], 4);

    expect(map[5], 6);
    expect(map[6], 8);
  });

  test("should remove multiple values with the same index", () {
    // given:
    final map = InfiniteIndexedMap(defaultValueBuilder: indexToValueBuilder);

    // when:
    map.removeAt(5);
    map.removeAt(5);

    // then:
    expect(map[4], 4);
    expect(map[5], 7);
  });
}
