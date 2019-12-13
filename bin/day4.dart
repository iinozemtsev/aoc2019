/*
--- Day 4: Secure Container ---
You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

However, they do remember a few key facts about the password:

It is a six-digit number.
The value is within the range given in your puzzle input.
Two adjacent digits are the same (like 22 in 122345).
Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
Other than the range rule, the following are true:

111111 meets these criteria (double 11, never decreases).
223450 does not meet these criteria (decreasing pair of digits 50).
123789 does not meet these criteria (no double).
How many different passwords within the range given in your puzzle input meet these criteria?

Your puzzle input is 235741-706948.
*/

List<int> toDigits(int number) {
  var result = <int>[];
  while (number > 0) {
    result.add(number % 10);
    number ~/= 10;
  }
  return result.reversed.toList();
}

List<int> countSameAdjacentDigits(List<int> digits) {
  var prev = digits[0];
  var result = <int>[];
  var count = 1;
  for (var i = 1; i < digits.length; i++) {
    var current = digits[i];
    if (current == prev) {
      count++;
    } else {
      result.add(count);
      count = 1;
      prev = current;
    }
  }
  result.add(count);
  return result;
}

bool numberMatches(int number) => digitsMatch(toDigits(number));

bool digitsMatch(List<int> input) =>
    containsRightAdjacentDigits(input) && neverDecreases(input);

// Part 1;
bool containsSameAdjacentDigits(List<int> input) {
  for (var i = 1; i < input.length; i++) {
    if (input[i] == input[i - 1]) return true;
  }
  return false;
}

// Part 2;
bool containsRightAdjacentDigits(List<int> input) =>
    countSameAdjacentDigits(input).any((c) => c == 2);

bool neverDecreases(List<int> input) {
  for (var i = 1; i < input.length; i++) {
    if (input[i] < input[i - 1]) return false;
  }
  return true;
}

void main() {
  var from = 235741;
  var to = 706948;
  print(Iterable<int>.generate(to - from + 1, (i) => from + i)
      .where((i) => numberMatches(i))
      .length);
}
