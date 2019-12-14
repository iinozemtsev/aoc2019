/*
--- Day 10: Monitoring Station ---

You fly into the asteroid belt and reach the Ceres monitoring station. The Elves
here have an emergency: they're having trouble tracking all of the asteroids and
can't be sure they're safe.

The Elves would like to build a new monitoring station in a nearby area of
space; they hand you a map of all of the asteroids in that region (your puzzle
input).

The map indicates whether each position is empty (.) or contains an asteroid
(#). The asteroids are much smaller than they appear on the map, and every
asteroid is exactly in the center of its marked position. The asteroids can be
described with X,Y coordinates where X is the distance from the left edge and Y
is the distance from the top edge (so the top-left corner is 0,0 and the
position immediately to its right is 1,0).

Your job is to figure out which asteroid would be the best place to build a new
monitoring station. A monitoring station can detect any asteroid to which it has
direct line of sight - that is, there cannot be another asteroid exactly between
them. This line of sight can be at any angle, not just lines aligned to the grid
or diagonally. The best location is the asteroid that can detect the largest
number of other asteroids.

For example, consider the following map:

.#..#
.....
#####
....#
...##

The best location for a new monitoring station on this map is the highlighted
asteroid at 3,4 because it can detect 8 asteroids, more than any other location.
(The only asteroid it cannot detect is the one at 1,0; its view of this asteroid
is blocked by the asteroid at 2,2.) All other asteroids are worse locations;
they can detect 7 or fewer other asteroids. Here is the number of other
asteroids a monitoring station on each asteroid could detect:

.7..7
.....
67775
....7
...87

Here is an asteroid (#) and some examples of the ways its line of sight might be
blocked. If there were another asteroid at the location of a capital letter, the
locations marked with the corresponding lowercase letter would be blocked and
could not be detected:

#.........
...A......
...B..a...
.EDCG....a
..F.c.b...
.....c....
..efd.c.gb
.......c..
....f...c.
...e..d..c

Here are some larger examples:

Best is 5,8 with 33 other asteroids detected:

......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####

Best is 1,2 with 35 other asteroids detected:

#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.

Best is 6,3 with 41 other asteroids detected:

.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..

Best is 11,13 with 210 other asteroids detected:

.#..##.###...#######
##.#########2##..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.#1####.###
##...#.####B#####...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##

Find the best location for a new monitoring station. How many other asteroids
can be detected from that location?

--- Part Two ---

Once you give them the coordinates, the Elves quickly deploy an Instant
Monitoring Station to the location and discover the worst: there are simply too
many asteroids.

The only solution is complete vaporization by giant laser.

Fortunately, in addition to an asteroid scanner, the new monitoring station also
comes equipped with a giant rotating laser perfect for vaporizing asteroids. The
laser starts by pointing up and always rotates clockwise, vaporizing any
asteroid it hits.

If multiple asteroids are exactly in line with the station, the laser only has
enough power to vaporize one of them before continuing its rotation. In other
words, the same asteroids that can be detected can be vaporized, but if
vaporizing one asteroid makes another one detectable, the newly-detected
asteroid won't be vaporized until the laser has returned to the same position by
rotating a full 360 degrees.

For example, consider the following map, where the asteroid with the new
monitoring station (and laser) is marked X:

.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....X...###..
..#.#.....#....##

The first nine asteroids to get vaporized, in order, would be:

.#....###24...#..
##...##.13#67..9#
##...#...5.8####.
..#.....X...###..
..#.#.....#....##

Note that some asteroids (the ones behind the asteroids marked 1, 5, and 7)
won't have a chance to be vaporized until the next full rotation. The laser
continues rotating; the next nine to be vaporized are:

.#....###.....#..
##...##...#.....#
##...#......1234.
..#.....X...5##..
..#.9.....8....76

The next nine to be vaporized are then:

.8....###.....#..
56...9#...#.....#
34...7...........
..2.....X....##..
..1..............

Finally, the laser completes its first full rotation (1 through 3), a second
rotation (4 through 8), and vaporizes the last asteroid (9) partway through its
third rotation:

......234.....6..
......1...5.....7
.................
........X....89..
.................

In the large example above (the one with the best monitoring station location at
11,13):

The 1st asteroid to be vaporized is at 11,12.
The 2nd asteroid to be vaporized is at 12,1.
The 3rd asteroid to be vaporized is at 12,2.
The 10th asteroid to be vaporized is at 12,8.
The 20th asteroid to be vaporized is at 16,0.
The 50th asteroid to be vaporized is at 16,9.
The 100th asteroid to be vaporized is at 10,16.
The 199th asteroid to be vaporized is at 9,6.
The 200th asteroid to be vaporized is at 8,2.
The 201st asteroid to be vaporized is at 10,9.
The 299th and final asteroid to be vaporized is at 11,1.

The Elves are placing bets on which will be the 200th asteroid to be vaporized.
nWin the bet by determining which asteroid that will be; what do you get if you
multiply its X coordinate by 100 and then add its Y coordinate? (For example,
8,2 becomes 802.)

*/

import 'package:test/test.dart';
import 'package:quiver/iterables.dart';
import 'dart:math';

extension PointExtension on Point<int> {
  Point<int> get asRationalTan {
    if (x == 0 || y == 0) return asSign;
    var gcd = x.gcd(y);
    return Point<int>(x ~/ gcd, y ~/ gcd);
  }

  double get tan => -x / y;

  Point<int> get asSign => Point<int>(x.sign, y.sign);
}

int compareTangents(Point<int> a, Point<int> b) {
  if (a == b) {
    return 0;
  }
  // first, check by sectors.
  const sectors = [
    Point<int>(0, -1), // up
    Point<int>(1, -1), // up-right
    Point<int>(1, 0), // right
    Point<int>(1, 1), // down-right
    Point<int>(0, 1), // down
    Point<int>(-1, 1), // down-left
    Point<int>(-1, 0), // left
    Point<int>(-1, -1), // up-left
  ];

  var sectorA = sectors.indexOf(a.asSign);
  var sectorB = sectors.indexOf(b.asSign);
  if (sectorA == -1 || sectorB == -1) {
    throw 'WAT $a $sectorA $b $sectorB';
  }
  if (sectorA != sectorB) {
    return sectorA - sectorB;
  }
  if (a.tan < b.tan) {
    return -1;
  } else if (a.tan > b.tan) {
    return 1;
  } else {
    throw 'Unexpected equal tangents of $a and $b';
  }
}

class Field {
  List<Point<int>> asteroids;
  Field._(this.asteroids);

  Map<Point<int>, List<Point<int>>> buildBuckets(Point<int> point) {
    var result = <Point<int>, List<Point<int>>>{};
    for (var asteroid in asteroids) {
      if (asteroid == point) {
        continue;
      }
      var diff = (asteroid - point).asRationalTan;
      result.putIfAbsent(diff, () => <Point<int>>[]).add(asteroid);
    }
    return result;
  }

  int visibleFrom(Point<int> point) => buildBuckets(point).length;

  List<Point<int>> destructionOrder(Point<int> point) {
    var buckets = buildBuckets(point);
    for (var bucket in buckets.values) {
      bucket.sort(
          (p1, p2) => p1.distanceTo(point).compareTo(p2.distanceTo(point)));
    }
    // Sort contents of each bucket by distance.
    // Sort by angle.
    var keys = buckets.keys.toList()..sort(compareTangents);

    var result = <Point<int>>[];

    while (keys.isNotEmpty) {
      var keysToRemove = <Point<int>>{};
      for (var key in keys) {
        var bucket = buckets[key];
        if (bucket.isEmpty) {
          keysToRemove.add(key);
        } else {
          result.add(bucket.removeAt(0));
        }
      }
      keys.removeWhere(keysToRemove.contains);
    }
    return result;
  }

  MapEntry<Point<int>, int> findBestAsteroid() {
    var asteroidToVisible = {
      for (var asteroid in asteroids) asteroid: visibleFrom(asteroid)
    };
    return max(asteroidToVisible.entries, (e1, e2) => e1.value - e2.value);
  }

  static Field parse(String map) {
    var result = Field._(<Point<int>>[]);
    var lines = map.trim().split('\n');
    var y = -1;
    for (var line in lines) {
      y++;
      var x = -1;
      for (var code in line.codeUnits) {
        x++;
        if (code == '#'.codeUnitAt(0)) {
          result.asteroids.add(Point<int>(x, y));
        }
      }
    }
    return result;
  }
}

void main() {
  group('part1', () {
    test('sample1', () {
      var best = Field.parse(
        '.#..#\n'
        '.....\n'
        '#####\n'
        '....#\n'
        '...##\n',
      ).findBestAsteroid();
      expect(best.key, Point<int>(3, 4));
      expect(best.value, 8);
    });
    test('sample2', () {
      var best = Field.parse(
        '.#..##.###...#######\n'
        '##.############..##.\n'
        '.#.######.########.#\n'
        '.###.#######.####.#.\n'
        '#####.##.#.##.###.##\n'
        '..#####..#.#########\n'
        '####################\n'
        '#.####....###.#.#.##\n'
        '##.#################\n'
        '#####.##.###..####..\n'
        '..######..##.#######\n'
        '####.##.####...##..#\n'
        '.#####..#.######.###\n'
        '##...#.##########...\n'
        '#.##########.#######\n'
        '.####.#.###.###.#.##\n'
        '....##.##.###..#####\n'
        '.#.#.###########.###\n'
        '#.#.#.#####.####.###\n'
        '###.##.####.##.#..##\n',
      ).findBestAsteroid();
      expect(best.key, Point<int>(11, 13));
      expect(best.value, 210);
    });

    test('sample3', () {
      var best = Field.parse(
        '......#.#.\n'
        '#..#.#....\n'
        '..#######.\n'
        '.#.#.###..\n'
        '.#..#.....\n'
        '..#....#.#\n'
        '#..#....#.\n'
        '.##.#..###\n'
        '##...#..#.\n'
        '.#....####\n',
      ).findBestAsteroid();
      expect(best.key, Point<int>(5, 8));
      expect(best.value, 33);
    });
    test('task', () {
      print(Field.parse(input).findBestAsteroid());
    });
  });

  group('part2', () {
    test('sample1', () {
      var field = Field.parse(
        '.#..##.###...#######\n'
        '##.############..##.\n'
        '.#.######.########.#\n'
        '.###.#######.####.#.\n'
        '#####.##.#.##.###.##\n'
        '..#####..#.#########\n'
        '####################\n'
        '#.####....###.#.#.##\n'
        '##.#################\n'
        '#####.##.###..####..\n'
        '..######..##.#######\n'
        '####.##.####...##..#\n'
        '.#####..#.######.###\n'
        '##...#.##########...\n'
        '#.##########.#######\n'
        '.####.#.###.###.#.##\n'
        '....##.##.###..#####\n'
        '.#.#.###########.###\n'
        '#.#.#.#####.####.###\n'
        '###.##.####.##.#..##\n',
      );
      var best = field.findBestAsteroid();
      var destructed = field.destructionOrder(best.key);
      // The 1st asteroid to be vaporized is at 11,12.
      expect(destructed[1 - 1], Point<int>(11, 12));
      // The 2nd asteroid to be vaporized is at 12,1.
      expect(destructed[2 - 1], Point<int>(12, 1));
      // The 3rd asteroid to be vaporized is at 12,2.
      expect(destructed[3 - 1], Point<int>(12, 2));
      // The 10th asteroid to be vaporized is at 12,8.
      expect(destructed[10 - 1], Point<int>(12, 8));
      // The 20th asteroid to be vaporized is at 16,0.
      expect(destructed[20 - 1], Point<int>(16, 0));
      // The 50th asteroid to be vaporized is at 16,9.
      expect(destructed[50 - 1], Point<int>(16, 9));
      // The 100th asteroid to be vaporized is at 10,16.
      expect(destructed[100 - 1], Point<int>(10, 16));
      // The 199th asteroid to be vaporized is at 9,6.
      expect(destructed[199 - 1], Point<int>(9, 6));
      // The 200th asteroid to be vaporized is at 8,2.
      expect(destructed[200 - 1], Point<int>(8, 2));
      // The 201st asteroid to be vaporized is at 10,9.
      expect(destructed[201 - 1], Point<int>(10, 9));
      // The 299th and final asteroid to be vaporized is at 11,1.
      expect(destructed[299 - 1], Point<int>(11, 1));
    });
    test('task', () {
      var field = Field.parse(input);
      var bet = field.destructionOrder(field.findBestAsteroid().key)[200 - 1];
      print(bet.x * 100 + bet.y);
    });
  });
}

const input = '''
#.#.##..#.###...##.#....##....###
...#..#.#.##.....#..##.#...###..#
####...#..#.##...#.##..####..#.#.
..#.#..#...#..####.##....#..####.
....##...#.##...#.#.#...#.#..##..
.#....#.##.#.##......#..#..#..#..
.#.......#.....#.....#...###.....
#.#.#.##..#.#...###.#.###....#..#
#.#..........##..###.......#...##
#.#.........##...##.#.##..####..#
###.#..#####...#..#.#...#..#.#...
.##.#.##.........####.#.#...##...
..##...#..###.....#.#...#.#..#.##
.#...#.....#....##...##...###...#
###...#..#....#............#.....
.#####.#......#.......#.#.##..#.#
#.#......#.#.#.#.......##..##..##
.#.##...##..#..##...##...##.....#
#.#...#.#.#.#.#..#...#...##...#.#
##.#..#....#..##.#.#....#.##...##
...###.#.#.......#.#..#..#...#.##
.....##......#.....#..###.....##.
........##..#.#........##.......#
#.##.##...##..###.#....#....###.#
..##.##....##.#..#.##..#.....#...
.#.#....##..###.#...##.#.#.#..#..
..#..##.##.#.##....#...#.........
#...#.#.#....#.......#.#...#..#.#
...###.##.#...#..#...##...##....#
...#..#.#.#..#####...#.#...####.#
##.#...#..##..#..###.#..........#
..........#..##..#..###...#..#...
.#.##...#....##.....#.#...##...##
''';
