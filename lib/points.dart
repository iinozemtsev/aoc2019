import 'dart:math';

extension Points on Iterable<Point<int>> {
  Rectangle<int> get boundingBox => fold<Rectangle<int>>(
      Rectangle<int>(0, 0, 0, 0),
      (r, p) => r.boundingBox(Rectangle<int>(p.x, p.y, 0, 0)));
}
