/*
--- Day 9: Sensor Boost ---

You've just said goodbye to the rebooted rover and left Mars when you receive a
faint distress signal coming from the asteroid belt. It must be the Ceres
monitoring station!

In order to lock on to the signal, you'll need to boost your sensors. The Elves
send up the latest BOOST program - Basic Operation Of System Test.

While BOOST (your puzzle input) is capable of boosting your sensors, for tenuous
safety reasons, it refuses to do so until the computer it runs on passes some
checks to demonstrate it is a complete Intcode computer.

Your existing Intcode computer is missing one key feature: it needs support for
parameters in relative mode.

Parameters in mode 2, relative mode, behave very similarly to parameters in
position mode: the parameter is interpreted as a position. Like position mode,
parameters in relative mode can be read from or written to.

The important difference is that relative mode parameters don't count from
address 0. Instead, they count from a value called the relative base. The
relative base starts at 0.

The address a relative mode parameter refers to is itself plus the current
relative base. When the relative base is 0, relative mode parameters and
position mode parameters with the same value refer to the same address.

For example, given a relative base of 50, a relative mode parameter of -7 refers
to memory address 50 + -7 = 43.

The relative base is modified with the relative base offset instruction:

Opcode 9 adjusts the relative base by the value of its only parameter. The
relative base increases (or decreases, if the value is negative) by the value of
the parameter.

For example, if the relative base is 2000, then after the instruction 109,19,
the relative base would be 2019. If the next instruction were 204,-34, then the
value at address 1985 would be output.

Your Intcode computer will also need a few other capabilities:

- The computer's available memory should be much larger than the initial
  program. Memory beyond the initial program starts with the value 0 and can be
  read or written like any other memory. (It is invalid to try to access memory
  at a negative address, though.)
- The computer should have support for large numbers. Some instructions near the
  beginning of the BOOST program will verify this capability. Here are some
  example programs that use these features:

109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and
produces a copy of itself as output.

1102,34915192,34915192,7,4,7,99,0 should output a 16-digit number.

104,1125899906842624,99 should output the large number in the middle.

The BOOST program will ask for a single input; run it in test mode by providing
it the value 1. It will perform a series of checks on each opcode, output any
opcodes (and the associated parameter modes) that seem to be functioning
incorrectly, and finally output a BOOST keycode.

Once your Intcode computer is fully functional, the BOOST program should report
no malfunctioning opcodes when run in test mode; it should only output a single
value, the BOOST keycode. What BOOST keycode does it produce?

--- Part Two ---

You now have a complete Intcode computer.

Finally, you can lock on to the Ceres distress signal! You just need to boost
your sensors using the BOOST program.

The program runs in sensor boost mode by providing the input instruction the
value 2. Once run, it will boost the sensors automatically, but it might take a
few seconds to complete the operation on slower hardware. In sensor boost mode,
the program will output a single value: the coordinates of the distress signal.

Run the BOOST program in sensor boost mode. What are the coordinates of the
distress signal?
*/

import 'package:aoc_2019/computer.dart';
import 'package:test/test.dart';

Memory mem(String input) =>
    Memory(input.split(',').map((s) => int.parse(s)).toList());

void main() {
  group('part1', () {
    test('sample1', () {
      var memory =
          mem('109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99');
      var expected = memory.toList();
      var computer = Computer(memory, Input([]))..run();
      expect(computer.output.output, expected);
    });
    test('sample2', () {
      expect(
          (Computer(Memory([104, 1125899906842624, 99]), Input([]))..run())
              .output
              .output
              .single,
          1125899906842624);
    });
    test('sample3', () {
      expect(
          (Computer(
                  Memory([1102, 34915192, 34915192, 7, 4, 7, 99, 0]), Input([]))
                ..run())
              .output
              .output
              .single
              .toString()
              .length,
          16);
    });
    test('task', () {
      print((Computer(mem(input), Input([1]))..run()).output.output);
    });
  });

  group('part2', () {
    test('task', () {
      print((Computer(mem(input), Input([2]))..run()).output.output);
    });
  });
}

const input = '1102,34463338,34463338,63,1007,63,34463338,63,100'
    '5,63,53,1102,1,3,1000,109,988,209,12,9,1000,209,6,'
    '209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,'
    '63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,'
    '0,99,4,0,104,0,99,4,17,104,0,99,0,0,1102,533,1,102'
    '4,1102,260,1,1023,1101,33,0,1016,1102,37,1,1017,11'
    '02,1,36,1009,1101,0,35,1011,1101,0,27,1004,1101,0,'
    '0,1020,1101,242,0,1029,1101,0,31,1018,1101,0,38,10'
    '07,1101,0,29,1015,1102,1,23,1006,1101,25,0,1002,11'
    '02,1,39,1008,1101,0,20,1001,1102,1,34,1012,1102,37'
    '0,1,1027,1101,30,0,1010,1102,24,1,1014,1101,21,0,1'
    '000,1101,22,0,1003,1102,1,26,1005,1101,0,267,1022,'
    '1101,1,0,1021,1101,28,0,1013,1101,0,32,1019,1101,2'
    '51,0,1028,1101,377,0,1026,1102,1,524,1025,109,4,21'
    '02,1,-4,63,1008,63,21,63,1005,63,203,4,187,1105,1,'
    '207,1001,64,1,64,1002,64,2,64,109,6,1201,-1,0,63,1'
    '008,63,36,63,1005,63,229,4,213,1105,1,233,1001,64,'
    '1,64,1002,64,2,64,109,18,2106,0,0,4,239,1001,64,1,'
    '64,1106,0,251,1002,64,2,64,109,-4,2105,1,-1,1001,6'
    '4,1,64,1105,1,269,4,257,1002,64,2,64,109,-6,1205,3'
    ',287,4,275,1001,64,1,64,1106,0,287,1002,64,2,64,10'
    '9,-19,1202,9,1,63,1008,63,41,63,1005,63,307,1105,1'
    ',313,4,293,1001,64,1,64,1002,64,2,64,109,8,2108,23'
    ',-1,63,1005,63,331,4,319,1106,0,335,1001,64,1,64,1'
    '002,64,2,64,109,-3,21101,40,0,10,1008,1014,40,63,1'
    '005,63,361,4,341,1001,64,1,64,1106,0,361,1002,64,2'
    ',64,109,28,2106,0,-5,1001,64,1,64,1106,0,379,4,367'
    ',1002,64,2,64,109,-30,1208,7,36,63,1005,63,401,4,3'
    '85,1001,64,1,64,1105,1,401,1002,64,2,64,109,-1,210'
    '1,0,6,63,1008,63,38,63,1005,63,427,4,407,1001,64,1'
    ',64,1105,1,427,1002,64,2,64,109,7,1207,-3,27,63,10'
    '05,63,445,4,433,1106,0,449,1001,64,1,64,1002,64,2,'
    '64,109,8,21107,41,40,0,1005,1016,465,1106,0,471,4,'
    '455,1001,64,1,64,1002,64,2,64,109,6,21107,42,43,-6'
    ',1005,1016,489,4,477,1105,1,493,1001,64,1,64,1002,'
    '64,2,64,109,-26,1208,8,28,63,1005,63,513,1001,64,1'
    ',64,1105,1,515,4,499,1002,64,2,64,109,29,2105,1,-1'
    ',4,521,1001,64,1,64,1105,1,533,1002,64,2,64,109,-1'
    '6,1201,-4,0,63,1008,63,23,63,1005,63,553,1105,1,55'
    '9,4,539,1001,64,1,64,1002,64,2,64,109,4,21101,43,0'
    ',-3,1008,1010,41,63,1005,63,579,1106,0,585,4,565,1'
    '001,64,1,64,1002,64,2,64,109,-8,1207,-3,24,63,1005'
    ',63,605,1001,64,1,64,1106,0,607,4,591,1002,64,2,64'
    ',109,1,2102,1,-2,63,1008,63,25,63,1005,63,627,1106'
    ',0,633,4,613,1001,64,1,64,1002,64,2,64,109,4,2108,'
    '25,-7,63,1005,63,653,1001,64,1,64,1106,0,655,4,639'
    ',1002,64,2,64,109,16,21102,44,1,-8,1008,1018,44,63'
    ',1005,63,681,4,661,1001,64,1,64,1106,0,681,1002,64'
    ',2,64,109,-32,1202,9,1,63,1008,63,22,63,1005,63,70'
    '3,4,687,1105,1,707,1001,64,1,64,1002,64,2,64,109,1'
    ',2107,26,9,63,1005,63,725,4,713,1105,1,729,1001,64'
    ',1,64,1002,64,2,64,109,21,1206,5,745,1001,64,1,64,'
    '1106,0,747,4,735,1002,64,2,64,109,3,1205,1,763,100'
    '1,64,1,64,1106,0,765,4,753,1002,64,2,64,109,-18,21'
    '01,0,5,63,1008,63,24,63,1005,63,785,1105,1,791,4,7'
    '71,1001,64,1,64,1002,64,2,64,109,6,21102,45,1,4,10'
    '08,1011,48,63,1005,63,811,1106,0,817,4,797,1001,64'
    ',1,64,1002,64,2,64,109,5,21108,46,46,1,1005,1013,8'
    '35,4,823,1106,0,839,1001,64,1,64,1002,64,2,64,109,'
    '-5,21108,47,45,8,1005,1015,855,1105,1,861,4,845,10'
    '01,64,1,64,1002,64,2,64,109,9,1206,4,875,4,867,110'
    '5,1,879,1001,64,1,64,1002,64,2,64,109,-7,2107,23,-'
    '6,63,1005,63,895,1106,0,901,4,885,1001,64,1,64,4,6'
    '4,99,21101,27,0,1,21101,915,0,0,1106,0,922,21201,1'
    ',51547,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,2'
    '1201,-2,-1,1,21101,942,0,0,1106,0,922,22102,1,1,-1'
    ',21201,-2,-3,1,21102,1,957,0,1106,0,922,22201,1,-1'
    ',-2,1106,0,968,21202,-2,1,-2,109,-3,2105,1,0';
