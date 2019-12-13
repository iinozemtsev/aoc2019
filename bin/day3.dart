/*

--- Day 3: Crossed Wires ---

The gravity assist was successful, and you're
well on your way to the Venus refuelling station. During the rush back on Earth,
the fuel management system wasn't completely installed, so that's next on the
priority list.

Opening the front panel reveals a jumble of wires. Specifically, two wires are
connected to a central port and extend outward on a grid. You trace the path
each wire takes as it leaves the central port, one wire per line of text (your
puzzle input).

The wires twist and turn, but the two wires occasionally cross paths. To fix the
circuit, you need to find the intersection point closest to the central port.
Because the wires are on a grid, use the Manhattan distance for this
measurement. While the wires do technically cross right at the central port
where they both start, this point does not count, nor does a wire count as
crossing with itself.

For example, if the first wire's path is R8,U5,L5,D3, then starting from the
central port (o), it goes right 8, up 5, left 5, and finally down 3:

...........
...........
...........
....+----+.
....|....|.
....|....|.
....|....|.
.........|.
.o-------+.
...........

Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4,
and left 4:

...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........

These wires cross at two locations (marked X), but the lower-left one is closer
to the central port: its distance is 3 + 3 = 6.

Here are a few more examples:

R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135
What is the Manhattan distance from the central port to the closest intersection?
*/

/*
--- Part Two ---

It turns out that this circuit is very timing-sensitive; you
actually need to minimize the signal delay.

To do this, calculate the number of steps each wire takes to reach each
intersection; choose the intersection where the sum of both wires' steps is
lowest. If a wire visits a position on the grid multiple times, use the steps
value from the first time it visits that position when calculating the total
value of a specific intersection.

The number of steps a wire takes is the total number of grid squares the wire
has entered to get to that location, including the intersection being
considered. Again consider the example from above:

...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........

In the above example, the intersection closest to the central port is reached
after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second
wire for a total of 20+20 = 40 steps.

However, the top-right intersection is better: the first wire takes only 8+5+2 =
15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

Here are the best steps for the extra examples from above:

R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps
What is the fewest combined steps the wires must take to reach an intersection?
*/


import 'dart:math';

var wire1 =
    'R991,U847,L239,U883,L224,D359,L907,D944,L79,U265,L107,D183,R850,U203,R828,D95,L258,D931,R792,U117,L309,U182,L633,D567,L828,D454,L660,U652,L887,D341,L497,D857,L299,U191,L882,D476,L968,U913,R453,D776,R169,D1,L193,D187,L564,U306,R815,U9,L434,U879,L816,D142,R16,U663,L54,D347,L557,U828,R597,D328,L636,U200,L383,D256,R162,U159,R37,D748,R440,D260,R48,D755,R762,U73,L357,U132,L745,D426,L797,U744,R945,D788,R585,U948,L20,D983,L335,U709,R488,U715,R229,D672,L13,D930,R903,D71,R620,U146,L835,U936,R542,D311,R375,U91,R362,U613,L78,D451,R220,D493,R404,D516,L550,U647,L908,U254,R827,D180,R902,U972,R56,U761,R912,U356,L921,D461,L65,D651,L230,U534,R143,D614,L526,D100,R76,D135,L572,U971,L219,D793,R638,U676,L58,D882,R299,D922,L198,D872,R736,D433,L999,U157,R795,U344,R213,D205,L928,D319,L775,U288,L903,U735,R128,D835,R496,U992,L875,D823,L833,D635,L700,U586,L587,U753,R849,U433,R473,U369,R891,U10,L152,U26,L893,U752,L258,D384,L491,U314,R722,U783,R801,U551,R141,U870,L662,D572,R671,U285,L435,D83,L260,U371,R849,U741,R661,U774,L583,U947,L460,U677,R809,D130,L288,D58,R107,U597,R21,U17,R99,U202,L324,U493,R824,U207,L460,D734,L154,D689,L366,D879,L353,U548,L307,D691,R70,U470,R649,D948,L346,U16,L257,D800,R954,D165,R376,D312,R491,D175,R426,U920,L532,U2,L556,D553,R320,D861,L129,D42,R112,U101,R455,D930,R122,D443,R28,D72,L670,U133,L599,D813,R169,D827,R235,D644,L297,U261,R405,D887,R218,D647,R108,D928,L779,D961,L110,U690,L214,U342,R449,D737,L651,U940,L370,D882,R10,D605,R369,U408,R167,D542,L819';
var wire2 =
    'L994,U274,R468,D607,R236,D712,R825,D228,L812,U796,R806,D874,L742,D297,L269,D853,R229,U319,R616,U77,L30,D879,L831,U241,R751,D20,R577,D949,L333,D520,L249,D165,R831,U965,L229,D412,L312,U31,L624,U593,L508,D359,R187,D682,R536,D266,L761,U412,R136,D296,L334,D180,R683,U93,L323,D864,L912,U262,L150,U437,L961,U224,R684,D62,R733,U302,R700,D417,R861,U394,L647,D564,R588,U184,L344,D812,L412,U409,R853,D548,L401,D670,R973,U490,R791,D784,R569,U852,R753,U510,R394,D517,R253,D418,R665,D742,L233,D311,L266,D395,L23,U595,R248,D243,L944,U830,L846,U44,L231,D399,R131,D825,R975,U476,L306,U716,L764,D730,L455,U27,L764,D274,R403,D376,L474,D724,R237,U870,R206,U172,R857,D993,R348,U591,R228,U534,L968,U722,L891,U656,L645,U831,L838,D641,R886,U185,R760,U531,R397,D849,L790,U839,L937,U508,L802,U166,L571,D153,L600,U356,R273,D185,L862,D159,L806,U503,R612,U324,R745,D398,L905,D31,L14,U965,R586,U808,L334,U390,R44,D132,R605,U999,R880,U579,R732,D717,L489,D577,R373,D913,R238,U532,R614,U518,R197,U129,R627,U5,R774,D922,L761,D540,R418,U419,R120,U637,R237,D73,L648,D162,L324,D911,L916,D886,L60,D961,R207,U102,R872,D884,R611,U360,R679,U974,R30,U895,L327,U256,L520,U977,R792,D356,R376,D39,L689,U159,R270,D621,L197,U138,L811,U100,L776,U936,R514,D69,R625,U99,L970,D519,R831,U227,L307,D271,R940,U690,L978,D257,R500,D971,R149,U291,L706,U177,L694,U230,R780,U604,R987,U222,L941,D511,R591,U156,L511,U207,L423,U324,R508,U338,L257,U547,R952,U927,L205,U476,L713,D170,L462,D848,R666,D836,R352,U414,L653,D657,R721,U807,L182,U823,L826';

enum State {
  empty,
  vertical,
  horizontal,
  cross,
}

String stateString(State state) => {
      State.empty: '.',
      State.vertical: '|',
      State.horizontal: '-',
      State.cross: 'x'
    }.putIfAbsent(
        state, () => throw ArgumentError('unsupported state: $state'));

const maxInt = 100500;
const minInt = -maxInt;

class Field {
  final _map = <int, Map<int, Set<int>>>{};

  Set<int> get(int x, int y) => _map
      .putIfAbsent(x, () => <int, Set<int>>{})
      .putIfAbsent(y, () => <int>{});

  void add(int x, int y, int wireId) => get(x, y).add(wireId);

  @override
  String toString() {
    var xmin = _map.keys.reduce(min);
    var xmax = _map.keys.reduce(max);
    var ymin = _map.values.expand((m) => m.keys).reduce(min);
    var ymax = _map.values.expand((m) => m.keys).reduce(max);

    var sb = StringBuffer();
    for (var y = ymax; y >= ymin; y--) {
      for (var x = xmin; x <= xmax; x++) {
        sb.write(get(x, y).length);
      }
      sb.writeln();
    }
    return sb.toString();
  }

  int get closestCross {
    var best = (crosses..sort((p1, p2) => p1.length - p2.length)).first;
    return best.x + best.y;
  }

  List<Point> get crosses {
    var result = <Point>[];
    for (var column in _map.entries) {
      var x = column.key;
      for (var cell in column.value.entries) {
        var y = cell.key;
        if (cell.value.length > 1) {
          result.add(Point(x, y));
        }
      }
    }
    return result;
  }

  /// Updates the field and returns new point.
  Point runStep(Point current, String step, int wireId) {
    var distance = int.parse(step.substring(1));
    var direction = step.substring(0, 1);
    var x = current.x;
    var y = current.y;
    var updateX = direction == 'R'
        ? ((int x) => ++x)
        : (direction == 'L' ? ((int x) => --x) : (int x) => x);
    var updateY = direction == 'U'
        ? ((int y) => ++y)
        : (direction == 'D' ? ((int y) => --y) : (int y) => y);
    while (distance-- > 0) {
      x = updateX(x);
      y = updateY(y);
      add(x, y, wireId);
    }
    return Point(x, y);
  }

  void runWire(String wire, int wireId) {
    var position = Point(0, 0);
    var steps = wire.split(',');
    for (var step in steps) {
      position = runStep(position, step, wireId);
    }
  }

  int totalLength(String wire1, String wire2, Point target) =>
      distanceToPoint(wire1, target) + distanceToPoint(wire2, target);

  int closestCrossByDistance(String wire1, String wire2) =>
      (crosses.map((c) => totalLength(wire1, wire2, c)).toList()..sort()).first;
}

class Point {
  final int x;
  final int y;

  int get length => x.abs() + y.abs();

  const Point(this.x, this.y);

  @override
  String toString() => '{$x, $y}';
}

void part1() {
  var field = Field()..runWire(wire1, 0)..runWire(wire2, 1);
  print(field.closestCross);
}

void part2() {
  var field = Field()..runWire(wire1, 0)..runWire(wire2, 1);
  print(field.closestCrossByDistance(wire1, wire2));
}

int distanceToPoint(String wire, Point target) {
  var result = 0;
  var point = Point(0, 0);
  for (var segmentString in wire.split(',')) {
    var start = point;
    var end = point;
    var length = int.parse(segmentString.substring(1));
    switch (segmentString.substring(0, 1)) {
      case 'U':
        end = Point(point.x, point.y + length);
        break;
      case 'D':
        end = Point(point.x, point.y - length);
        break;
      case 'L':
        end = Point(point.x - length, point.y);
        break;
      case 'R':
        end = Point(point.x + length, point.y);
        break;
      default:
        throw ArgumentError('wat?');
    }

    var len = segmentToPoint(start, end, target);
    if (len != -1) {
      return result + len;
    }

    result += length;
    point = end;
  }
  throw ArgumentError('$wire does not intersect $target');
}

// -1 if segment doesn't contain point
int segmentToPoint(Point from, Point to, Point target) {
  if (from.x == to.x) {
    // vertical segment
    if (target.x != from.x) {
      return -1;
    }

    if (target.y < min(from.y, to.y)) {
      return -1;
    }

    if (target.y > max(from.y, to.y)) {
      return -1;
    }

    return (from.y - target.y).abs();
  }

  if (from.y == to.y) {
    // horizontal segment
    if (target.y != from.y) {
      return -1;
    }

    if (target.x < min(from.x, to.x)) {
      return -1;
    }

    if (target.x > max(from.x, to.x)) {
      return -1;
    }

    return (from.x - target.x).abs();
  }
  throw ArgumentError('bad segment');
}
void main() => part2();
