import 'dart:math';

extension Points on Iterable<Point<int>> {
  Rectangle<int> get boundingBox => fold<Rectangle<int>>(
      Rectangle<int>(0, 0, 0, 0),
      (r, p) => r.boundingBox(Rectangle<int>(p.x, p.y, 0, 0)));
}

const offsetUp = Point<int>(0, -1);
const offsetDown = Point<int>(0, 1);
const offsetLeft = Point<int>(-1, 0);
const offsetRight = Point<int>(1, 0);
const offsets = [offsetUp, offsetRight, offsetDown, offsetLeft];

enum Direction { up, right, down, left }

const directionOffsetMap = {
  Direction.up: offsetUp,
  Direction.right: offsetRight,
  Direction.down: offsetDown,
  Direction.left: offsetLeft,
};

final offsetDirectionMap = {
  offsetUp: Direction.up,
  offsetRight: Direction.right,
  offsetDown: Direction.down,
  offsetLeft: Direction.left,
};

extension PointExtension on Point<int> {
  Direction toDirection() =>
      offsetDirectionMap[this] ??
      (throw UnsupportedError('$this is not a direction'));
}

extension DirectionExtension on Direction {
  Direction rotateLeft() => Direction.values[(index + 3) % 4];
  Direction rotateRight() => Direction.values[(index + 1) % 4];
  Point<int> toOffset() =>
      directionOffsetMap[this] ??
      (throw UnsupportedError('bad direction $this'));
}

Iterable<Point<int>> neighbors(Point<int> point, [Rectangle<int> bounds]) =>
    offsets
        .map((o) => o + point)
        .where((p) => bounds == null || bounds.containsPoint(p));
