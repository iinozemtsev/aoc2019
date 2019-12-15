/*
--- Day 15: Oxygen System ---

Out here in deep space, many things can go wrong. Fortunately, many of those
things have indicator lights. Unfortunately, one of those lights is lit: the
oxygen system for part of the ship has failed!

According to the readouts, the oxygen system must have failed days ago after a
rupture in oxygen tank two; that section of the ship was automatically sealed
once oxygen levels went dangerously low. A single remotely-operated repair droid
is your only option for fixing the oxygen system.

The Elves' care package included an Intcode program (your puzzle input) that you
can use to remotely control the repair droid. By running that program, you can
direct the repair droid to the oxygen system and fix the problem.

The remote control program executes the following steps in a loop forever:

- Accept a movement command via an input instruction.
- Send the movement command to the repair droid.
- Wait for the repair droid to finish the movement operation.
- Report on the status of the repair droid via an output instruction.

Only four movement commands are understood: north (1), south (2), west (3), and
east (4). Any other command is invalid. The movements differ in direction, but
not in distance: in a long enough east-west hallway, a series of commands like
4,4,4,4,3,3,3,3 would leave the repair droid back where it started.

The repair droid can reply with any of the following status codes:

0: The repair droid hit a wall. Its position has not changed.
1: The repair droid has moved one step in the requested direction.
2: The repair droid has moved one step in the requested direction; its new
position is the location of the oxygen system.

You don't know anything about the area around the repair droid, but you can
figure it out by watching the status codes.

For example, we can draw the area using D for the droid, # for walls, . for
locations the droid can traverse, and empty space for unexplored locations.
Then, the initial state looks like this:

......
......
...D..
......
......
To make the droid go north, send it 1. If it replies with 0, you know that location is a wall and that the droid didn't move:

......
...#..
...D..
......
......

To move east, send 4; a reply of 1 means the movement was successful:

......
...#..
....D.
......
......

Then, perhaps attempts to move north (1), south (2), and east (4) are all met
with replies of 0:

......
...##.
....D#
....#.
......

Now, you know the repair droid is in a dead end. Backtrack with 3 (which you
already know will get a reply of 1 because you already know that location is
open):

......
...##.
...D.#
....#.
......

Then, perhaps west (3) gets a reply of 0, south (2) gets a reply of 1, south
again (2) gets a reply of 0, and then west (3) gets a reply of 2:

......
...##.
..#..#
..D.#.
...#..

Now, because of the reply of 2, you know you've found the oxygen system! In this
example, it was only 2 moves away from the repair droid's starting position.

What is the fewest number of movement commands required to move the repair droid
from its starting position to the location of the oxygen system?

--- Part Two ---

You quickly repair the oxygen system; oxygen gradually fills the area.

Oxygen starts in the location containing the repaired oxygen system. It takes
one minute for oxygen to spread to all open locations that are adjacent to a
location that already contains oxygen. Diagonal locations are not adjacent.

In the example above, suppose you've used the droid to explore the area fully
and have the following map (where locations that currently contain oxygen are
marked O):

_##___
#..##_
#.#..#
#.O.#_
_###__

Initially, the only location which contains oxygen is the location of the
repaired oxygen system. However, after one minute, the oxygen spreads to all
open (.) locations that are adjacent to a location containing oxygen:

_##___
#..##_
#.#..#
#OOO#_
_###__

After a total of two minutes, the map looks like this:

_##___
#..##_
#O#O.#
#OOO#_
_###__

After a total of three minutes:

_##___
#O.##_
#O#OO#
#OOO#_
_###__

And finally, the whole region is full of oxygen after a total of four minutes:

_##___
#OO##_
#O#OO#
#OOO#_
_###__

So, in this example, all locations contain oxygen after 4 minutes.

Use the repair droid to get a complete map of the area. How many minutes will it
take to fill with oxygen?

*/

import 'dart:collection';
import 'dart:math';

import 'package:aoc_2019/computer.dart';
import 'package:aoc_2019/points.dart';
import 'package:quiver/iterables.dart';
import 'package:test/test.dart';

class FillNode implements NodeBase<FillNode> {
  FillNode parent;
  Point<int> location;
  Rectangle<int> bounds;
  Map<Point<int>, Result> map;

  final int depth;
  FillNode({this.parent, this.location, this.bounds, this.map})
      : depth = parent == null ? 0 : parent.depth + 1;

  @override
  List<FillNode> expand() => Direction.values
      .map((d) => location + d.toOffset())
      .where((point) => bounds.containsPoint(point))
      .map((point) =>
          FillNode(parent: this, location: point, bounds: bounds, map: map))
      .toList();

  @override
  Result visit() => map[location];

  static FillNode startNode(Point<int> start, Map<Point<int>, Result> map) =>
      FillNode(
          parent: null,
          location: start,
          map: map,
          bounds: map.keys.boundingBox);

  @override
  bool operator ==(dynamic other) =>
      other is FillNode && other.location == location;

  @override
  int get hashCode => location.hashCode;

  @override
  String toString() => location.toString();
}

/// BFS node for searching the stuff.
class Node implements NodeBase<Node> {
  Node parent;
  Computer computer;
  Direction direction;

  /// location where we would be if the move is successful.
  Point<int> location;

  Node({this.parent, this.computer, this.direction, this.location});
  static Node startNode() => Node(
      parent: null,
      computer: Computer(Memory(input), Input([])),
      location: Point<int>(0, 0),
      direction: null);
  @override
  List<Node> expand() {
    var result = <Node>[];
    for (var direction in Direction.values) {
      result.add(Node(
          parent: this,
          computer: computer.clone(),
          direction: direction,
          location: location + direction.toOffset()));
    }
    return result;
  }

  @override
  Result visit() {
    computer.input.input.add(direction.toInput());
    computer.step();
    while (computer.state == State.ready) {
      computer.step();
    }
    var result = fromOutput(computer.output.output.last);
    computer.output.output.clear();
    return result;
  }

  @override
  bool operator ==(dynamic other) =>
      other is Node && other.location == location;

  @override
  int get hashCode => location.hashCode;
}

enum Result { wall, ok, goal }

extension ResultExtension on Result {
  String draw() => {Result.wall: '#', Result.ok: '.', Result.goal: '@'}
      .putIfAbsent(this, () => throw UnsupportedError('cannot draw $this'));
}

Result fromOutput(int output) => Result.values[output];

enum Direction { north, south, west, east }

extension DirectionExtension on Direction {
  int toInput() => index + 1;

  Point<int> toOffset() => {
        Direction.north: Point<int>(0, -1),
        Direction.south: Point<int>(0, 1),
        Direction.west: Point<int>(-1, 0),
        Direction.east: Point<int>(1, 0),
      }.putIfAbsent(
          this, () => throw UnsupportedError('invalid direction $this'));
}

abstract class NodeBase<S extends NodeBase<S>> {
  List<S> expand();
  Result visit();
}

Map<S, Result> bfs<S extends NodeBase<S>>(NodeBase<S> start) {
  var fringe = Queue<S>();
  var visited = <S>{};
  fringe.addAll(start.expand());
  visited.add(start);

  var map = <S, Result>{};
  while (fringe.isNotEmpty) {
    var next = fringe.removeFirst();
    visited.add(next);
    var result = next.visit();
    map[next] = result;
    if (result == Result.wall) {
      continue;
    }
    if (result == Result.ok || result == Result.goal) {
      var more = next.expand();
      for (var node in more) {
        if (!visited.contains(node)) {
          fringe.addLast(node);
        }
      }
      continue;
    }

    throw UnsupportedError('unsupported result: $result while visiting $next');
  }
  return map;
}

void main() {
  group('part1', () {
    test('task', () {
      var node = Node.startNode();
      var map = bfs(node);
      var result = map.entries.singleWhere((e) => e.value == Result.goal).key;
      var path = <Point<int>>[];
      while (result != null) {
        path.add(result.location);
        result = result.parent;
      }
      print(path.length);
    });
  });

  group('part2', () {
    test('task', () {
      var node = Node.startNode();
      var map = bfs(node);
      var start = map.entries.singleWhere((e) => e.value == Result.goal).key;
      var tileByPoint = {
        for (var entry in map.entries) entry.key.location: entry.value
      };
      tileByPoint[Point<int>(0, 0)] = Result.ok;
      var fillMap = bfs(FillNode.startNode(start.location, tileByPoint));
      print(max<FillNode>(fillMap.keys, (f1, f2) => f1.depth - f2.depth).depth - 1);
    });
  });
}

const input = [
  3,
  1033,
  1008,
  1033,
  1,
  1032,
  1005,
  1032,
  31,
  1008,
  1033,
  2,
  1032,
  1005,
  1032,
  58,
  1008,
  1033,
  3,
  1032,
  1005,
  1032,
  81,
  1008,
  1033,
  4,
  1032,
  1005,
  1032,
  104,
  99,
  101,
  0,
  1034,
  1039,
  1001,
  1036,
  0,
  1041,
  1001,
  1035,
  -1,
  1040,
  1008,
  1038,
  0,
  1043,
  102,
  -1,
  1043,
  1032,
  1,
  1037,
  1032,
  1042,
  1105,
  1,
  124,
  102,
  1,
  1034,
  1039,
  1002,
  1036,
  1,
  1041,
  1001,
  1035,
  1,
  1040,
  1008,
  1038,
  0,
  1043,
  1,
  1037,
  1038,
  1042,
  1106,
  0,
  124,
  1001,
  1034,
  -1,
  1039,
  1008,
  1036,
  0,
  1041,
  1002,
  1035,
  1,
  1040,
  102,
  1,
  1038,
  1043,
  102,
  1,
  1037,
  1042,
  1106,
  0,
  124,
  1001,
  1034,
  1,
  1039,
  1008,
  1036,
  0,
  1041,
  1001,
  1035,
  0,
  1040,
  1002,
  1038,
  1,
  1043,
  101,
  0,
  1037,
  1042,
  1006,
  1039,
  217,
  1006,
  1040,
  217,
  1008,
  1039,
  40,
  1032,
  1005,
  1032,
  217,
  1008,
  1040,
  40,
  1032,
  1005,
  1032,
  217,
  1008,
  1039,
  37,
  1032,
  1006,
  1032,
  165,
  1008,
  1040,
  33,
  1032,
  1006,
  1032,
  165,
  1101,
  0,
  2,
  1044,
  1106,
  0,
  224,
  2,
  1041,
  1043,
  1032,
  1006,
  1032,
  179,
  1101,
  0,
  1,
  1044,
  1105,
  1,
  224,
  1,
  1041,
  1043,
  1032,
  1006,
  1032,
  217,
  1,
  1042,
  1043,
  1032,
  1001,
  1032,
  -1,
  1032,
  1002,
  1032,
  39,
  1032,
  1,
  1032,
  1039,
  1032,
  101,
  -1,
  1032,
  1032,
  101,
  252,
  1032,
  211,
  1007,
  0,
  62,
  1044,
  1106,
  0,
  224,
  1101,
  0,
  0,
  1044,
  1106,
  0,
  224,
  1006,
  1044,
  247,
  101,
  0,
  1039,
  1034,
  1002,
  1040,
  1,
  1035,
  102,
  1,
  1041,
  1036,
  101,
  0,
  1043,
  1038,
  1001,
  1042,
  0,
  1037,
  4,
  1044,
  1106,
  0,
  0,
  60,
  10,
  88,
  42,
  71,
  78,
  10,
  10,
  70,
  23,
  65,
  29,
  47,
  58,
  86,
  53,
  77,
  61,
  77,
  63,
  18,
  9,
  20,
  68,
  45,
  15,
  67,
  3,
  95,
  10,
  14,
  30,
  81,
  53,
  3,
  83,
  46,
  31,
  95,
  43,
  94,
  40,
  21,
  54,
  93,
  91,
  35,
  80,
  9,
  17,
  81,
  94,
  59,
  83,
  49,
  96,
  61,
  63,
  24,
  85,
  69,
  82,
  45,
  71,
  48,
  39,
  32,
  69,
  93,
  11,
  90,
  19,
  78,
  54,
  79,
  66,
  6,
  13,
  76,
  2,
  67,
  69,
  10,
  9,
  66,
  43,
  73,
  2,
  92,
  39,
  12,
  99,
  33,
  89,
  18,
  9,
  78,
  11,
  96,
  23,
  55,
  96,
  49,
  12,
  85,
  93,
  49,
  22,
  70,
  93,
  59,
  76,
  68,
  55,
  66,
  54,
  32,
  34,
  36,
  53,
  64,
  84,
  87,
  61,
  43,
  79,
  7,
  9,
  66,
  40,
  69,
  9,
  76,
  92,
  18,
  78,
  49,
  39,
  80,
  32,
  70,
  52,
  74,
  37,
  86,
  11,
  77,
  51,
  15,
  28,
  84,
  19,
  13,
  75,
  28,
  86,
  3,
  82,
  93,
  15,
  79,
  61,
  93,
  93,
  31,
  87,
  43,
  67,
  44,
  83,
  78,
  43,
  46,
  46,
  12,
  89,
  19,
  85,
  44,
  95,
  65,
  24,
  70,
  93,
  50,
  98,
  72,
  66,
  80,
  23,
  87,
  19,
  97,
  40,
  25,
  9,
  49,
  6,
  81,
  35,
  9,
  52,
  71,
  27,
  63,
  3,
  96,
  94,
  21,
  24,
  48,
  79,
  67,
  72,
  72,
  15,
  85,
  93,
  22,
  95,
  34,
  3,
  63,
  21,
  79,
  9,
  51,
  92,
  45,
  87,
  25,
  41,
  80,
  13,
  88,
  68,
  66,
  18,
  85,
  75,
  39,
  80,
  17,
  54,
  93,
  89,
  65,
  21,
  91,
  73,
  53,
  60,
  69,
  29,
  82,
  99,
  5,
  22,
  65,
  9,
  69,
  61,
  80,
  63,
  38,
  71,
  61,
  61,
  11,
  68,
  30,
  74,
  11,
  26,
  53,
  59,
  97,
  2,
  12,
  74,
  79,
  44,
  73,
  72,
  27,
  17,
  34,
  92,
  26,
  27,
  88,
  66,
  5,
  97,
  34,
  81,
  86,
  30,
  35,
  6,
  64,
  36,
  34,
  65,
  80,
  12,
  90,
  65,
  95,
  21,
  90,
  55,
  43,
  71,
  89,
  56,
  97,
  91,
  27,
  27,
  73,
  80,
  34,
  22,
  48,
  89,
  84,
  35,
  88,
  90,
  47,
  4,
  32,
  77,
  31,
  2,
  82,
  66,
  76,
  43,
  74,
  68,
  56,
  78,
  36,
  59,
  66,
  58,
  75,
  89,
  96,
  51,
  51,
  97,
  34,
  49,
  86,
  70,
  26,
  46,
  89,
  43,
  99,
  97,
  66,
  32,
  51,
  32,
  77,
  33,
  86,
  92,
  56,
  68,
  64,
  39,
  83,
  55,
  25,
  98,
  24,
  56,
  73,
  21,
  98,
  39,
  24,
  67,
  21,
  4,
  76,
  10,
  32,
  91,
  53,
  82,
  37,
  59,
  72,
  63,
  78,
  43,
  67,
  2,
  72,
  69,
  50,
  71,
  19,
  72,
  92,
  51,
  12,
  93,
  61,
  88,
  24,
  84,
  35,
  93,
  30,
  63,
  70,
  7,
  78,
  83,
  42,
  63,
  6,
  25,
  24,
  73,
  76,
  22,
  99,
  68,
  14,
  85,
  14,
  75,
  32,
  88,
  42,
  47,
  97,
  2,
  91,
  97,
  51,
  79,
  12,
  71,
  91,
  7,
  1,
  87,
  82,
  21,
  98,
  63,
  37,
  19,
  85,
  1,
  48,
  77,
  54,
  76,
  12,
  92,
  28,
  91,
  25,
  85,
  88,
  8,
  92,
  32,
  67,
  18,
  56,
  51,
  67,
  58,
  80,
  59,
  77,
  76,
  25,
  7,
  73,
  58,
  72,
  96,
  75,
  15,
  27,
  37,
  23,
  83,
  58,
  68,
  83,
  50,
  67,
  41,
  39,
  89,
  24,
  1,
  83,
  63,
  8,
  64,
  54,
  76,
  50,
  3,
  89,
  97,
  74,
  48,
  15,
  91,
  22,
  37,
  71,
  77,
  9,
  1,
  85,
  38,
  23,
  58,
  10,
  75,
  86,
  72,
  80,
  59,
  24,
  64,
  7,
  63,
  85,
  53,
  61,
  89,
  68,
  7,
  80,
  4,
  68,
  56,
  39,
  66,
  31,
  69,
  6,
  7,
  76,
  88,
  17,
  89,
  42,
  64,
  56,
  11,
  97,
  65,
  64,
  71,
  88,
  61,
  31,
  32,
  53,
  88,
  99,
  55,
  73,
  20,
  90,
  10,
  86,
  32,
  50,
  89,
  53,
  83,
  42,
  80,
  28,
  63,
  98,
  38,
  85,
  72,
  57,
  88,
  23,
  52,
  96,
  77,
  39,
  65,
  88,
  40,
  26,
  91,
  56,
  1,
  94,
  51,
  94,
  24,
  20,
  81,
  74,
  23,
  45,
  72,
  56,
  22,
  84,
  70,
  44,
  50,
  68,
  32,
  98,
  51,
  75,
  3,
  61,
  75,
  59,
  3,
  7,
  98,
  76,
  45,
  78,
  47,
  74,
  60,
  69,
  78,
  54,
  67,
  29,
  63,
  47,
  79,
  72,
  57,
  73,
  44,
  63,
  98,
  6,
  93,
  36,
  20,
  27,
  90,
  77,
  39,
  44,
  64,
  68,
  47,
  48,
  69,
  78,
  29,
  76,
  48,
  1,
  81,
  10,
  67,
  32,
  72,
  47,
  89,
  83,
  18,
  39,
  85,
  65,
  97,
  15,
  59,
  13,
  74,
  29,
  84,
  50,
  80,
  94,
  8,
  27,
  83,
  67,
  43,
  75,
  52,
  96,
  17,
  82,
  29,
  83,
  45,
  85,
  82,
  71,
  76,
  44,
  30,
  10,
  91,
  16,
  7,
  31,
  63,
  2,
  68,
  75,
  46,
  70,
  28,
  93,
  91,
  17,
  13,
  81,
  57,
  93,
  32,
  27,
  65,
  61,
  93,
  11,
  84,
  10,
  66,
  14,
  83,
  14,
  77,
  26,
  77,
  13,
  86,
  21,
  84,
  87,
  87,
  34,
  99,
  69,
  88,
  1,
  74,
  61,
  72,
  54,
  93,
  16,
  76,
  54,
  86,
  63,
  94,
  13,
  79,
  24,
  97,
  0,
  0,
  21,
  21,
  1,
  10,
  1,
  0,
  0,
  0,
  0,
  0,
  0
];
