import 'package:quiver/iterables.dart';

class Memory {
  final Map<int, int> _state;
  Memory(List<int> initialState)
      : _state = {
          for (var entry in enumerate(initialState)) entry.index: entry.value
        };

  int operator [](int i) => _state.putIfAbsent(i, () => 0);
  operator []=(int i, int val) {
    if (i < 0) throw ArgumentError.value(i, 'i', 'WAT');
    _state[i] = val;
  }

  List<int> toList() {
    var result = <int>[];
    for (var i = 0;
        i <=
            max<int>(
                _state.entries.where((e) => e.value != 0).map((e) => e.key));
        i++) {
      result.add(this[i]);
    }
    return result;
  }
}

class Output {
  final output = <int>[];
  void write(int i) {
    output.add(i);
  }
}

class Input {
  final List<int> input;
  int _position = 0;
  Input(this.input);
  bool canRead() => _position < input.length;
  int read() {
    var r = input[_position++];
    return r;
  }
}

enum State { ready, waitingInput, stopped }

abstract class Mode {
  int read(int param, Memory state, int relativeBase);
  void write(int param, int value, Memory state, int relativeBase);
}

class ImmediateMode implements Mode {
  @override
  int read(int position, Memory state, int relativeBase) => state[position];

  @override
  void write(int position, int value, Memory state, int relativeBase) =>
      throw UnsupportedError('ImmediateMode does not support writes.');
}

class PositionMode implements Mode {
  @override
  int read(int position, Memory state, int relativeBase) =>
      state[state[position]];

  @override
  void write(int position, int value, Memory state, int relativeBase) =>
      state[state[position]] = value;
}

class RelativeMode implements Mode {
  @override
  int read(int position, Memory state, int relativeBase) {
    return state[state[position] + relativeBase];
  }

  @override
  void write(int position, int value, Memory state, int relativeBase) =>
      state[state[position] + relativeBase] = value;
}

class Modes {
  final List<Mode> _modes;
  Modes._(this._modes);
  static Modes fromOpcode(int opcode) =>
      Modes._(unpackModes(opcode).map(modeFromCode).toList());
  Mode operator [](int i) => i < _modes.length ? _modes[i] : PositionMode();

  @override
  String toString() => _modes.toString();
}

Mode modeFromCode(int code) => {
      0: PositionMode(),
      1: ImmediateMode(),
      2: RelativeMode()
    }.putIfAbsent(code, () => throw ArgumentError.value(code, 'code', 'WAT'));
List<int> unpackModes(int opcode) {
  var result = <int>[];
  opcode ~/= 100;
  while (opcode > 0) {
    result.add(opcode % 10);
    opcode ~/= 10;
  }
  return result;
}

const $sum = 1;
const $mul = 2;
const $read = 3;
const $write = 4;
const $jumpIfTrue = 5;
const $jumpIfFalse = 6;
const $lessThan = 7;
const $equals = 8;
const $setBase = 9;

const $stop = 99;

class Computer {
  int position = 0;
  int relativeBase = 0;
  Memory memory;
  State state = State.ready;
  Input input;
  Output output = Output();
  Computer(this.memory, this.input);

  void stop() => state = State.stopped;

  void run() {
    step();
    while (state == State.ready) {
      step();
    }
  }

  int read(int argNum, Modes modes) =>
      modes[argNum].read(position + argNum + 1, memory, relativeBase);
  void write(int argNum, int value, Modes modes) =>
      modes[argNum].write(position + argNum + 1, value, memory, relativeBase);

  void step() {
    if (state == State.stopped) throw UnsupportedError('already stopped');
    var opcode = memory[position];
    var instruction = opcode % 100;
    var modes = Modes.fromOpcode(opcode);
    if (state == State.waitingInput && instruction != $read) {
      throw UnsupportedError(
          'Instruction $instruction does not match state (wating for input)');
    }
    switch (instruction) {
      case $sum:
        var left = read(0, modes);
        var right = read(1, modes);
        write(2, left + right, modes);
        position += 4;
        break;
      case $mul:
        var left = read(0, modes);
        var right = read(1, modes);
        write(2, left * right, modes);
        position += 4;
        break;
      case $read:
        if (!input.canRead()) {
          state = State.waitingInput;
        } else {
          write(0, input.read(), modes);
          position += 2;
          state = State.ready;
        }
        break;
      case $write:
        var val = read(0, modes);
        output.write(val);
        position += 2;
        break;
      case $stop:
        stop();
        break;
      case $jumpIfTrue:
        var arg = read(0, modes);
        if (arg != 0) {
          position = read(1, modes);
        } else {
          position += 3;
        }
        break;
      case $jumpIfFalse:
        var arg = read(0, modes);
        if (arg == 0) {
          position = read(1, modes);
        } else {
          position += 3;
        }
        break;
      case $lessThan:
        var first = read(0, modes);
        var second = read(1, modes);
        write(2, (first < second) ? 1 : 0, modes);
        position += 4;
        break;
      case $equals:
        var first = read(0, modes);
        var second = read(1, modes);
        write(2, (first == second) ? 1 : 0, modes);
        position += 4;
        break;
      case $setBase:
        relativeBase += read(0, modes);
        position += 2;
        break;

      default:
        throw 'WAT $instruction';
    }
  }
}
