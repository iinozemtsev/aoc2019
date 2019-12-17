/*
--- Day 16: Flawed Frequency Transmission ---

You're 3/4ths of the way through the gas giants. Not only do roundtrip signals
to Earth take five hours, but the signal quality is quite bad as well. You can
clean up the signal with the Flawed Frequency Transmission algorithm, or FFT.

As input, FFT takes a list of numbers. In the signal you received (your puzzle
input), each number is a single digit: data like 15243 represents the sequence
1, 5, 2, 4, 3.

FFT operates in repeated phases. In each phase, a new list is constructed with
the same length as the input list. This new list is also used as the input for
the next phase.

Each element in the new list is built by multiplying every value in the input
list by a value in a repeating pattern and then adding up the results. So, if
the input list were 9, 8, 7, 6, 5 and the pattern for a given element were 1, 2,
3, the result would be 9*1 + 8*2 + 7*3 + 6*1 + 5*2 (with each input element on
the left and each value in the repeating pattern on the right of each
multiplication). Then, only the ones digit is kept: 38 becomes 8, -17 becomes 7,
and so on.

While each element in the output array uses all of the same input array
elements, the actual repeating pattern to use depends on which output element is
being calculated. The base pattern is 0, 1, 0, -1. Then, repeat each value in
the pattern a number of times equal to the position in the output list being
considered. Repeat once for the first element, twice for the second element,
three times for the third element, and so on. So, if the third element of the
output list is being calculated, repeating the values would produce: 0, 0, 0, 1,
1, 1, 0, 0, 0, -1, -1, -1.

When applying the pattern, skip the very first value exactly once. (In other
words, offset the whole pattern left by one.) So, for the second element of the
output list, the actual pattern used would be: 0, 1, 1, 0, 0, -1, -1, 0, 0, 1,
1, 0, 0, -1, -1, ....

After using this process to calculate each element of the output list, the phase
is complete, and the output list of this phase is used as the new input list for
the next phase, if any.

Here are the first eight digits of the final output list after 100 phases for
some larger inputs:

80871224585914546619083218645595 becomes 24176176.
19617804207202209144916044189917 becomes 73745418.
69317163492948606335995924319873 becomes 52432133.

After 100 phases of FFT, what are the first eight digits in the final output
list?

--- Part Two ---
Now that your FFT is working, you can decode the real signal.

The real signal is your puzzle input repeated 10000 times. Treat this new signal
as a single input list. Patterns are still calculated as before, and 100 phases
of FFT are still applied.

The first seven digits of your initial input signal also represent the message
offset. The message offset is the location of the eight-digit message in the
final output list. Specifically, the message offset indicates the number of
digits to skip before reading the eight-digit message. For example, if the first
seven digits of your initial input signal were 1234567, the eight-digit message
would be the eight digits after skipping 1,234,567 digits of the final output
list. Or, if the message offset were 7 and your final output list were
98765432109876543210, the eight-digit message would be 21098765. (Of course,
your real message offset will be a seven-digit number, not a one-digit number
like 7.)

Here is the eight-digit message in the final output list after 100 phases. The
message offset given in each input has been highlighted. (Note that the inputs
given below are repeated 10000 times to find the actual starting input lists.)

- '0303673'2577212944063491565474664 becomes 84462026.
- '0293510'9699940807407585447034323 becomes 78725270.
- '0308177'0884921959731165446850517 becomes 53553731.

After repeating your input signal 10000 times and running 100 phases of FFT,
what is the eight-digit message embedded in the final output list? */

import 'package:quiver/iterables.dart';
import 'package:test/test.dart';

const _basePattern = [0, 1, 0, -1];

Iterable<int> pattern(int index) => cycle<int>(
    _basePattern.expand((e) => Iterable.generate(index + 1, (_) => e))).skip(1);

List<int> transform(List<int> input) =>
    enumerate(input).map((entry) => nth(input, entry.index)).toList();

String format(List<int> output) => output.join('');

List<int> parse(String input) =>
    input.codeUnits.map((u) => u - '0'.codeUnitAt(0)).toList();
int nth(List<int> input, int index) {
  var result = 0;
  var patternIterator = pattern(index).iterator;
  var inputIterator = input.iterator;
  while (inputIterator.moveNext()) {
    patternIterator.moveNext();
    result += patternIterator.current * inputIterator.current;
  }
  return result.abs() % 10;
}

String task1(String input) {
  var list = parse(input);
  var count = 100;
  while (count > 0) {
    count--;
    list = transform(list);
  }
  return format(list).substring(0, 8);
}

void main() {
  group('part1', () {
    test('sample1', () {
      /*

      Given the input signal 12345678, below are four phases of FFT. Within each
      phase, each output digit is calculated on a single line with the result at
      the far right; each multiplication operation shows the input digit on the
      left and the pattern value on the right:

      Input signal: 12345678*/
      var input = '12345678';
      // 1*1  + 2*0  + 3*-1 + 4*0  + 5*1  + 6*0  + 7*-1 + 8*0  = 4
      expect(pattern(0).take(8), [1, 0, -1, 0, 1, 0, -1, 0]);
      expect(parse(input), [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(nth(parse(input), 0), 4);
      /*1*0  + 2*1  + 3*1  + 4*0  + 5*0  + 6*-1 + 7*-1 + 8*0  = 8
        1*0  + 2*0  + 3*1  + 4*1  + 5*1  + 6*0  + 7*0  + 8*0  = 2
        1*0  + 2*0  + 3*0  + 4*1  + 5*1  + 6*1  + 7*1  + 8*0  = 2
        1*0  + 2*0  + 3*0  + 4*0  + 5*1  + 6*1  + 7*1  + 8*1  = 6
        1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*1  + 7*1  + 8*1  = 1
        1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*0  + 7*1  + 8*1  = 5
        1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*0  + 7*0  + 8*1  = 8

        After 1 phase: 48226158*/

      input = format(transform(parse(input)));
      expect(input, '48226158');

      // After 2 phases: 34040438
      input = format(transform(parse(input)));
      expect(input, '34040438');
      // After 3 phases: 03415518
      input = format(transform(parse(input)));
      expect(input, '03415518');

      // After 4 phases: 01029498
      input = format(transform(parse(input)));
      expect(input, '01029498');
    });
    test('sample2', () {
      // Here are the first eight digits of the final output list after 100
      // phases for some larger inputs:

      expect(task1('80871224585914546619083218645595'), '24176176');
      expect(task1('19617804207202209144916044189917'), '73745418');
      expect(task1('69317163492948606335995924319873'), '52432133');
    });

    test('task', () {
      // After 100 phases of FFT, what are the first eight digits in the final
      // output list?
      print(task1(input));
    });
  });
  group('part2', () {
    test('task', () {
      // No idea how this works, took from reddit just to move on.
      var inp = input;
      var offset = int.parse(inp.substring(0, 7));

      inp = (inp * 10000).substring(offset);
      var list = parse(inp);
      for (var i = 0; i < 100; i++) {
        var sum = 0;
        for (var j = list.length - 1; j >= 0; j--) {
          list[j] = (sum += list[j]) % 10;
        }
      }
      print('Part 2: ${list.sublist(0, 8).join('')}');
    });
  });
}

const input = '59791911701697178620772166487621926539855976237879'
    '30086987293130353212240471170681317665705380248183'
    '30152142267050587040170994112840464733952110225466'
    '62450403964137283487707691563442026697656820695854'
    '45382669048761117286035828625585066806950768793641'
    '05995204756806951805273270764791197648971194941613'
    '66645257480353063266653306023935874821274026377407'
    '05195831629199514459362479275555392364839216959789'
    '72220586137256209202332838690365019507539700291821'
    '81770358827133737490530431859833065926816798051237'
    '51095474220993995737650636492621987915052460605699'
    '65727437739120303976956132038350115246776400442378'
    '24961662635530619875905369208905866913334027160178';
