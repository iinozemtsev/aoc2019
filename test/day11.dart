/*

On the way to Jupiter, you're pulled over by the Space Police.

"Attention, unmarked spacecraft! You are in violation of Space Law! All
spacecraft must have a clearly visible registration identifier! You have 24
hours to comply or be sent to Space Jail!"

Not wanting to be sent to Space Jail, you radio back to the Elves on Earth for
help. Although it takes almost three hours for their reply signal to reach you,
they send instructions for how to power up the emergency hull painting robot and
even provide a small Intcode program (your puzzle input) that will cause it to
paint your ship appropriately.

There's just one problem: you don't have an emergency hull painting robot.

You'll need to build a new emergency hull painting robot. The robot needs to be
able to move around on the grid of square panels on the side of your ship,
detect the color of its current panel, and paint its current panel black or
white. (All of the panels are currently black.)

The Intcode program will serve as the brain of the robot. The program uses input
instructions to access the robot's camera: provide 0 if the robot is over a
black panel or 1 if the robot is over a white panel. Then, the program will
output two values:

First, it will output a value indicating the color to paint the panel the robot
is over: 0 means to paint the panel black, and 1 means to paint the panel white.
Second, it will output a value indicating the direction the robot should turn: 0
means it should turn left 90 degrees, and 1 means it should turn right 90
degrees. After the robot turns, it should always move forward exactly one panel.
The robot starts facing up.

The robot will continue running for a while like this and halt when it is
finished drawing. Do not restart the Intcode computer inside the robot during
this process.

For example, suppose the robot is about to start running. Drawing black panels
as ., white panels as #, and the robot pointing the direction it is facing (< ^
> v), the initial state and region near the robot looks like this:

.....
.....
..^..
.....
.....

The panel under the robot (not visible here because a ^ is shown instead) is
also black, and so any input instructions at this point should be provided 0.
Suppose the robot eventually outputs 1 (paint white) and then 0 (turn left).
After taking these actions and moving forward one panel, the region now looks
like this:

.....
.....
.<#..
.....
.....

Input instructions should still be provided 0. Next, the robot might output 0
(paint black) and then 0 (turn left):

.....
.....
..#..
.v...
.....

After more outputs (1,0, 1,0):

.....
.....
..^..
.##..
.....

The robot is now back where it started, but because it is now on a white panel,
input instructions should be provided 1. After several more outputs (0,1, 1,0,
1,0), the area looks like this:

.....
..<#.
...#.
.##..
.....

Before you deploy the robot, you should probably have an estimate of the area it
will cover: specifically, you need to know the number of panels it paints at
least once, regardless of color. In the example above, the robot painted 6
panels at least once. (It painted its starting panel twice, but that panel is
still only counted once; it also never painted the panel it ended on.)

Build a new emergency hull painting robot and run the Intcode program on it. How
many panels does it paint at least once?

--- Part Two ---

You're not sure what it's trying to paint, but it's definitely not a
registration identifier. The Space Police are getting impatient.

Checking your external ship cameras again, you notice a white panel marked
"emergency hull painting robot starting panel". The rest of the panels are still
black, but it looks like the robot was expecting to start on a white panel, not
a black one.

Based on the Space Law Space Brochure that the Space Police attached to one of
your windows, a valid registration identifier is always eight capital letters.
After starting the robot on a single white panel instead, what registration
identifier does it paint on your hull? */

import 'dart:math';

import 'package:aoc_2019/computer.dart';
import 'package:test/test.dart';
import 'package:aoc_2019/points.dart';

enum Color { black, white }
extension ColorExtension on Color {
  String draw() => this == Color.black ? '.' : '#';
}
class Field {
  final painted = <Point<int>, Color>{};

  Color operator [](Point<int> pt) {
    if (painted.containsKey(pt)) {
      return painted[pt];
    }
    return Color.black;
  }

  operator []=(Point<int> pt, Color value) => painted[pt] = value;

  String draw() {
    var sb = StringBuffer();
    var bounds = painted.keys.boundingBox;
    for(var y = bounds.top; y <= bounds.bottom; y++) {
      sb.writeln();
      for (var x = bounds.left; x < bounds.right; x++) {
        sb.write(this[Point<int>(x,y)].draw());
      }
    }
    return sb.toString();
  }
}

class Robot {
  var position = Point<int>(0, 0);
  var direction = Direction.up;

  Computer computer;

  Robot(Memory program) : computer = Computer(program, Input([]));

  void step(Field field) {
    // Input the color of the current panel.
    computer.input.input.add(field[position].index);
    computer.run();
    var instructions = List.of(computer.output.output);
    computer.output.output.clear();
    // Paint
    field[position] = Color.values[instructions[0]];
    // Move
    direction =
        instructions[1] == 0 ? direction.rotateLeft() : direction.rotateRight();
    position += direction.toOffset();
  }

  void run(Field field) {
    while (computer.state != State.stopped) {
      step(field);
    }
  }
}

void main() {
  group('part1', () {
    test('task', () {
      var field = Field();
      var robot = Robot(Memory(input));
      robot.run(field);
      print(field.painted.length);
    });
  });

  group('part2', () {
    test('task', () {
      var field = Field();
      var robot = Robot(Memory(input));
      field[robot.position] = Color.white;
      robot.run(field);
      print(field.draw());
    });
  });
}

const input = [
  3,
  8,
  1005,
  8,
  314,
  1106,
  0,
  11,
  0,
  0,
  0,
  104,
  1,
  104,
  0,
  3,
  8,
  1002,
  8,
  -1,
  10,
  1001,
  10,
  1,
  10,
  4,
  10,
  108,
  1,
  8,
  10,
  4,
  10,
  1002,
  8,
  1,
  28,
  2,
  2,
  16,
  10,
  1,
  1108,
  7,
  10,
  1006,
  0,
  10,
  1,
  5,
  14,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  108,
  1,
  8,
  10,
  4,
  10,
  102,
  1,
  8,
  65,
  1006,
  0,
  59,
  2,
  109,
  1,
  10,
  1006,
  0,
  51,
  2,
  1003,
  12,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  1001,
  10,
  1,
  10,
  4,
  10,
  108,
  1,
  8,
  10,
  4,
  10,
  1001,
  8,
  0,
  101,
  1006,
  0,
  34,
  1,
  1106,
  0,
  10,
  1,
  1101,
  17,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  1008,
  8,
  0,
  10,
  4,
  10,
  1001,
  8,
  0,
  135,
  3,
  8,
  1002,
  8,
  -1,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  108,
  0,
  8,
  10,
  4,
  10,
  1001,
  8,
  0,
  156,
  3,
  8,
  1002,
  8,
  -1,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  108,
  0,
  8,
  10,
  4,
  10,
  1001,
  8,
  0,
  178,
  1,
  108,
  19,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  108,
  0,
  8,
  10,
  4,
  10,
  1002,
  8,
  1,
  204,
  1,
  1006,
  17,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  108,
  1,
  8,
  10,
  4,
  10,
  102,
  1,
  8,
  230,
  1006,
  0,
  67,
  1,
  103,
  11,
  10,
  1,
  1009,
  19,
  10,
  1,
  109,
  10,
  10,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  1008,
  8,
  0,
  10,
  4,
  10,
  101,
  0,
  8,
  268,
  3,
  8,
  102,
  -1,
  8,
  10,
  101,
  1,
  10,
  10,
  4,
  10,
  1008,
  8,
  1,
  10,
  4,
  10,
  1002,
  8,
  1,
  290,
  2,
  108,
  13,
  10,
  101,
  1,
  9,
  9,
  1007,
  9,
  989,
  10,
  1005,
  10,
  15,
  99,
  109,
  636,
  104,
  0,
  104,
  1,
  21101,
  48210224024,
  0,
  1,
  21101,
  0,
  331,
  0,
  1105,
  1,
  435,
  21101,
  0,
  937264165644,
  1,
  21101,
  0,
  342,
  0,
  1105,
  1,
  435,
  3,
  10,
  104,
  0,
  104,
  1,
  3,
  10,
  104,
  0,
  104,
  0,
  3,
  10,
  104,
  0,
  104,
  1,
  3,
  10,
  104,
  0,
  104,
  1,
  3,
  10,
  104,
  0,
  104,
  0,
  3,
  10,
  104,
  0,
  104,
  1,
  21101,
  235354025051,
  0,
  1,
  21101,
  389,
  0,
  0,
  1105,
  1,
  435,
  21102,
  29166169280,
  1,
  1,
  21102,
  400,
  1,
  0,
  1105,
  1,
  435,
  3,
  10,
  104,
  0,
  104,
  0,
  3,
  10,
  104,
  0,
  104,
  0,
  21102,
  709475849060,
  1,
  1,
  21102,
  1,
  423,
  0,
  1106,
  0,
  435,
  21102,
  868498428684,
  1,
  1,
  21101,
  434,
  0,
  0,
  1105,
  1,
  435,
  99,
  109,
  2,
  21201,
  -1,
  0,
  1,
  21101,
  0,
  40,
  2,
  21102,
  1,
  466,
  3,
  21101,
  456,
  0,
  0,
  1105,
  1,
  499,
  109,
  -2,
  2105,
  1,
  0,
  0,
  1,
  0,
  0,
  1,
  109,
  2,
  3,
  10,
  204,
  -1,
  1001,
  461,
  462,
  477,
  4,
  0,
  1001,
  461,
  1,
  461,
  108,
  4,
  461,
  10,
  1006,
  10,
  493,
  1101,
  0,
  0,
  461,
  109,
  -2,
  2106,
  0,
  0,
  0,
  109,
  4,
  2102,
  1,
  -1,
  498,
  1207,
  -3,
  0,
  10,
  1006,
  10,
  516,
  21102,
  1,
  0,
  -3,
  21201,
  -3,
  0,
  1,
  21201,
  -2,
  0,
  2,
  21102,
  1,
  1,
  3,
  21102,
  535,
  1,
  0,
  1106,
  0,
  540,
  109,
  -4,
  2106,
  0,
  0,
  109,
  5,
  1207,
  -3,
  1,
  10,
  1006,
  10,
  563,
  2207,
  -4,
  -2,
  10,
  1006,
  10,
  563,
  21202,
  -4,
  1,
  -4,
  1106,
  0,
  631,
  21201,
  -4,
  0,
  1,
  21201,
  -3,
  -1,
  2,
  21202,
  -2,
  2,
  3,
  21101,
  582,
  0,
  0,
  1105,
  1,
  540,
  22102,
  1,
  1,
  -4,
  21102,
  1,
  1,
  -1,
  2207,
  -4,
  -2,
  10,
  1006,
  10,
  601,
  21101,
  0,
  0,
  -1,
  22202,
  -2,
  -1,
  -2,
  2107,
  0,
  -3,
  10,
  1006,
  10,
  623,
  22102,
  1,
  -1,
  1,
  21101,
  623,
  0,
  0,
  105,
  1,
  498,
  21202,
  -2,
  -1,
  -2,
  22201,
  -4,
  -2,
  -4,
  109,
  -5,
  2105,
  1,
  0
];
