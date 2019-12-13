List<int> toDigits(int number) {
  var result = <int>[];
  while (number > 0) {
    result.add(number % 10);
    number ~/= 10;
  }
  return result.reversed.toList();
}
