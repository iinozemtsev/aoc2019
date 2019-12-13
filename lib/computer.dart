class Memory {
  List<int> state;
  Memory(List<int> initialState) : state = List.of(initialState);

  int operator [](int i) => state[i];
  operator []=(int i, int val) => state[i] = val;
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
  int read(int param, Memory state);
  void write(int param, int value, Memory state);
}

class ImmediateMode implements Mode {
  @override
  int read(int position, Memory state) => state[position];

  @override
  void write(int position, int value, Memory state) =>
      throw UnsupportedError('ImmediateMode does not support writes.');
}

class PositionMode implements Mode {
  @override
  int read(int position, Memory state) => state[state[position]];

  @override
  void write(int position, int value, Memory state) =>
      state[state[position]] = value;
}

class Modes {
  final List<int> _codes;
  Modes._(this._codes);
  static Modes fromOpcode(int opcode) => Modes._(unpackModes(opcode));
  Mode operator [](int i) =>
      i < _codes.length && _codes[i] == 1 ? ImmediateMode() : PositionMode();
}

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

const $stop = 99;

class Computer {
  int position = 0;
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
      modes[argNum].read(position + argNum + 1, memory);
  void write(int argNum, int value, Modes modes) =>
      modes[argNum].write(position + argNum + 1, value, memory);

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
        output.write(read(0, modes));
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

      default:
        throw 'WAT';
    }
  }
}
