import 'package:draggable_builder/draggable_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int indexToValueBuilder(int index) => index;

  // given:
  late InfiniteIndexedValueProvider<int> map;

  setUp(() {
    map = InfiniteIndexedValueProvider(indexToValueBuilder);
  });

  test("should return a value", () {
    // expect:
    expect(map[5], 5);
  });

  test("should set value at index", () {
    // when:
    map[5] = 100;

    // then:
    expect(map[4], 4);
    expect(map[5], 100);
    expect(map[6], 6);
  });

  test("should insert value at index", () {
    // when:
    map.insertAt(5, 100);

    // then:
    expect(map[4], 4);
    expect(map[5], 100);
    expect(map[6], 5);
  });

  test("should remove at index", () {
    // when:
    map.removeAt(5);

    // then:
    expect(map[4], 4);
    expect(map[5], 6);
  });

  group("with a value set at index", () {
    // with:
    setUp(() {
      map[5] = 100;
    });

    test("should set value at a lower index", () {
      // when:
      map[3] = 99;

      // then:
      expect(map[3], 99);
      expect(map[4], 4);
      expect(map[5], 100);
    });

    test("should set value at same index", () {
      // when:
      map[5] = 101;

      // then:
      expect(map[4], 4);
      expect(map[5], 101);
      expect(map[6], 6);
    });

    test("should set value with a higher index", () {
      // when:
      map[7] = 101;

      // then:
      expect(map[5], 100);
      expect(map[6], 6);
      expect(map[7], 101);
    });

    test("should insert value at lower index", () {
      // when:
      map.insertAt(3, 99);

      // then:
      expect(map[3], 99);
      expect(map[4], 3);
      expect(map[5], 4);
      expect(map[6], 100);
    });

    test("should insert value at same index", () {
      // when:
      map.insertAt(5, 99);

      // then:
      expect(map[4], 4);
      expect(map[5], 99);
      expect(map[6], 100);
      expect(map[7], 6);
    });

    test("should insert value at higher index", () {
      // when:
      map.insertAt(7, 101);

      // then:
      expect(map[5], 100);
      expect(map[6], 6);
      expect(map[7], 101);
      expect(map[8], 7);
    });

    test("should remove a value at a lower index", () {
      // when:
      map.removeAt(3);

      // then:
      expect(map[2], 2);
      expect(map[3], 4);
      expect(map[4], 100);
      expect(map[5], 6);
    });

    test("should remove a value at the same index", () {
      // when:
      map.removeAt(5);

      // then:
      expect(map[4], 4);
      expect(map[5], 6);
    });

    test("should remove a value at a higher index", () {
      // when:
      map.removeAt(7);

      // then:
      expect(map[4], 4);
      expect(map[5], 100);
      expect(map[6], 6);
      expect(map[7], 8);
    });
  });

  group("with a value removed at index", () {
    // with:
    setUp(() {
      map.removeAt(5);
    });

    test("should remove another value at a lower index", () {
      // when:
      map.removeAt(3);

      // then:
      expect(map[2], 2);
      expect(map[3], 4);
      expect(map[4], 6);
      expect(map[5], 7);
    });

    test("should remove another value at the same index", () {
      // when:
      map.removeAt(5);

      // then:
      expect(map[4], 4);
      expect(map[5], 7);
    });

    test("should remove another value at a higher index", () {
      // when:
      map.removeAt(7);

      // then:
      expect(map[4], 4);
      expect(map[5], 6);
      expect(map[6], 7);
      expect(map[7], 9);
    });

    test("should set value at lower index", () {
      // when:
      map[3] = 100;

      // then:
      expect(map[3], 100);
      expect(map[4], 4);
      expect(map[5], 6);
    });

    test("should set value at index", () {
      // when:
      map[5] = 100;

      // then:
      expect(map[5], 100);
    });

    test("should set value at higher index", () {
      // when:
      map[6] = 100;

      // then:
      expect(map[5], 6);
      expect(map[6], 100);
    });
  });
}
