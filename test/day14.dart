/*

--- Day 14: Space Stoichiometry ---

As you approach the rings of Saturn, your ship's low fuel indicator turns on.
There isn't any fuel here, but the rings have plenty of raw material. Perhaps
your ship's Inter-Stellar Refinery Union brand nanofactory can turn these raw
materials into fuel.

You ask the nanofactory to produce a list of the reactions it can perform that
are relevant to this process (your puzzle input). Every reaction turns some
quantities of specific input chemicals into some quantity of an output chemical.
Almost every chemical is produced by exactly one reaction; the only exception,
ORE, is the raw material input to the entire process and is not produced by a
reaction.

You just need to know how much ORE you'll need to collect before you can produce
one unit of FUEL.

Each reaction gives specific quantities for its inputs and output; reactions
cannot be partially run, so only whole integer multiples of these quantities can
be used. (It's okay to have leftover chemicals when you're done, though.) For
example, the reaction 1 A, 2 B, 3 C => 2 D means that exactly 2 units of
chemical D can be produced by consuming exactly 1 A, 2 B and 3 C. You can run
the full reaction as many times as necessary; for example, you could produce 10
D by consuming 5 A, 10 B, and 15 C.

Suppose your nanofactory produces the following list of reactions:

10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL

The first two reactions use only ORE as inputs; they indicate that you can
produce as much of chemical A as you want (in increments of 10 units, each 10
costing 10 ORE) and as much of chemical B as you want (each costing 1 ORE). To
produce 1 FUEL, a total of 31 ORE is required: 1 ORE to produce 1 B, then 30
more ORE to produce the 7 + 7 + 7 + 7 = 28 A (with 2 extra A wasted) required in
the reactions to convert the B into C, C into D, D into E, and finally E into
FUEL. (30 A is produced because its reaction requires that it is created in
increments of 10.)

Or, suppose you have the following list of reactions:

9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL

The above list of reactions requires 165 ORE to produce 1 FUEL:

Consume 45 ORE to produce 10 A.
Consume 64 ORE to produce 24 B.
Consume 56 ORE to produce 40 C.
Consume 6 A, 8 B to produce 2 AB.
Consume 15 B, 21 C to produce 3 BC.
Consume 16 C, 4 A to produce 4 CA.
Consume 2 AB, 3 BC, 4 CA to produce 1 FUEL.

Here are some larger examples:

13312 ORE for 1 FUEL:

157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT

180697 ORE for 1 FUEL:

2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF

2210736 ORE for 1 FUEL:

171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX

Given the list of reactions in your puzzle input, what is the minimum amount of
ORE required to produce exactly 1 FUEL?

--- Part Two --- 

After collecting ORE for a while, you check your cargo hold: 1
trillion (1000000000000) units of ORE.

With that much ore, given the examples above:

The 13312 ORE-per-FUEL example could produce 82892753 FUEL.
The 180697 ORE-per-FUEL example could produce 5586022 FUEL.
The 2210736 ORE-per-FUEL example could produce 460664 FUEL.
Given 1 trillion ORE, what is the maximum amount of FUEL you can produce?
*/

import 'package:test/test.dart';

class Unit {
  String name;
  Unit(this.name);
  @override
  String toString() => name;

  @override
  bool operator ==(dynamic other) => other is Unit && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class Amount {
  final int amount;
  final Unit unit;
  Amount(this.amount, this.unit);

  @override
  String toString() => '$amount $unit';

  Amount operator +(Amount other) {
    if (other.unit != unit) {
      throw ArgumentError('canot add ${other.unit}to $unit');
    }
    return Amount(amount + other.amount, unit);
  }

  Amount operator -(Amount other) => this + (-other);
  Amount operator -() => Amount(-amount, unit);

  Amount operator *(int num) {
    return Amount(amount * num, unit);
  }

  static Amount parse(String input) {
    var parts = input.trim().split(' ');
    if (parts.length != 2) {
      throw ArgumentError.value(input, 'input', 'Must be <num> <unit>');
    }
    return Amount(int.parse(parts.first), Unit(parts.last));
  }

  static Amount zero(Unit unit) => Amount(0, unit);
}

class Reaction {
  List<Amount> input;
  Amount output;

  Reaction(this.input, this.output);

  @override
  String toString() => '${input.join(', ')} => $output';

  static Reaction parse(String line) {
    var parts = line.split('=>');
    if (parts.length != 2) {
      throw ArgumentError.value(line, 'line', 'Unexpected reaction format');
    }
    var input =
        parts.first.split(',').map((part) => Amount.parse(part)).toList();
    var output = Amount.parse(parts.last);
    return Reaction(input, output);
  }
}

class Reactions {
  Map<Unit, Reaction> reactions;

  Reactions(List<Reaction> reactions)
      : reactions = {for (var r in reactions) r.output.unit: r};

  Reaction operator [](Unit output) => reactions[output];

  static Reactions parse(String input) => Reactions(
      input.trim().split('\n').map((line) => Reaction.parse(line)).toList());
}

/// Tracks amounts. Amount can be negative.
class Inventory {
  var amounts = <Unit, Amount>{};

  Inventory clone() => Inventory()..amounts = Map.of(amounts);

  Amount operator [](Unit unit) => amounts[unit] ?? Amount.zero(unit);
  void add(Amount amount) => amounts[amount.unit] = this[amount.unit] + amount;

  void remove(Amount amount) => add(-amount);

  void runReaction(Reaction reaction, [int count = 1]) {
    for (var input in reaction.input) {
      remove(input * count);
    }
    add(reaction.output * count);
  }

  void produceFuel(Reactions reactions, [int count = 1]) {
    runReaction(reactions[fuel], count);
    compensate(reactions);
  }

  void compensate(Reactions reactions) {
    while (true) {
      var missingEntry = amounts.entries.firstWhere(
          (entry) => entry.key != ore && entry.value.amount < 0,
          orElse: () => null);
      if (missingEntry == null) {
        break;
      }
      var reaction = reactions[missingEntry.key];
      var count = (-missingEntry.value.amount + reaction.output.amount - 1) ~/
          reaction.output.amount;
      runReaction(reaction, count);
    }
  }
}

int task1(String input) {
  var reactions = Reactions.parse(input);
  var inventory = Inventory();
  inventory.produceFuel(reactions);
  return -inventory.amounts[ore].amount;
}

void check(String spec) {
  var lines = spec.trim().split('\n');
  var target = int.parse(lines.first.split(' ').first);
  expect(task1(lines.sublist(2).join('\n')), target);
}

int task2(String input) {
  var reactions = Reactions.parse(input);
  var inventory = Inventory();
  var budget = 1000000000000;
  inventory.produceFuel(reactions);
  var estimate = budget ~/ -inventory[ore].amount;
  inventory.produceFuel(reactions, estimate - 1);

  bool inBudget(Inventory inv) => inv[ore].amount + budget > 0;
  var step = estimate;
  var result = estimate;
  var backup = inventory.clone();
  var backupResult = result;
  while (step > 0) {
    inventory.produceFuel(reactions, step);

    result += step;
    if (!inBudget(inventory)) {
      // roll back and decrease step.
      result = backupResult;
      inventory = backup.clone();
      step ~/= 2;
    } else {
      backup = inventory.clone();
      backupResult = result;
    }
  }

  return result;
}

final ore = Unit('ORE');
final fuel = Unit('FUEL');

void main() {
  group('part1', () {
    test('sample1', () {
      expect(task1('''9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
'''), 165);
    });
    test('sample2', () {
      check('''13312 ORE for 1 FUEL:

157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
''');
    });
    test('sample3', () {
      check('''180697 ORE for 1 FUEL:

2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
''');
    });
    test('sample4', () {
      check('''2210736 ORE for 1 FUEL:

171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
''');
    });
    test('task', () {
      print(task1(input));
    });
  });
  group('part2', () {
    test('sample2', () {
      expect(task2('''157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
'''), 82892753);
    });
    test('sample3', () {
      expect(task2('''2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
'''), 5586022);
    });
    test('sample4', () {
      expect(task2('''
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
'''), 460664);
    });
    test('task', () {
      print(task2(input));
    });
  });
}

var input = '''
2 LFPRM, 4 GPNQ => 2 VGZVD
1 KXFHM, 14 SJLP => 8 MGRTM
2 HBXVT, 3 HNHC, 5 BDLV => 1 DKTW
2 MGRTM, 8 RVTB => 4 DFMW
2 SJLP => 9 PXTS
1 NXBG => 6 FXBXZ
32 LPSQ => 9 GSDXD
13 LZGTR => 4 ZRMJ
1 FTPQ, 16 CPCS => 5 HNHC
2 THQH, 2 NDJG, 5 MSKT => 4 LRZV
2 BDLV, 9 HBXVT, 21 NXBG => 7 PLRK
16 LNSKQ, 41 KXFHM, 1 DKTW, 1 NCPSZ, 3 ZCSB, 11 MGRTM, 19 WNJWP, 11 KRBG => 1 FUEL
5 FTPQ, 1 HBXVT => 4 BDLV
15 LSDX, 1 GFJW, 1 QDHJT => 4 NKHQV
9 CZHTP, 1 FRPTK => 6 SNBS
17 LFLVS, 2 WCFT => 8 KGJQ
6 CMHLP => 1 SJLP
144 ORE => 3 KQKXZ
3 GFJW, 1 RVTB, 1 GPNQ => 2 NXBG
4 BDLV => 5 CMHLP
2 LSDX => 1 LZGTR
156 ORE => 3 NDJG
136 ORE => 8 MSKT
4 BDLV, 1 NKHQV, 1 RVTB => 7 LNSKQ
1 LRZV, 3 WCFT => 2 HBXVT
5 KGJQ, 1 SWBSN => 7 QHFX
2 DQHBG => 4 LPSQ
6 GSDXD => 3 LSDX
11 RWLD, 3 BNKVZ, 4 PXTS, 3 XTRQC, 5 LSDX, 5 LMHL, 36 MGRTM => 4 ZCSB
8 CPCS => 2 FRPTK
5 NDJG => 3 WCFT
1 GDQG, 1 QHFX => 4 KXFHM
160 ORE => 3 THQH
20 GFJW, 2 DQHBG => 6 RVTB
2 FXBXZ, 1 WNJWP, 1 VGZVD => 5 RWLD
3 DQHBG => 7 SWBSN
7 QHFX => 8 CPCS
14 HBXVT => 3 VCDW
5 FRPTK => 7 NGDX
1 HWFQ => 4 LFLVS
2 CPCS => 6 ZTKSW
9 KGJQ, 8 ZTKSW, 13 BDLV => 6 GDQG
13 LMHL, 1 LZGTR, 18 BNKVZ, 11 VCDW, 9 DFMW, 11 FTPQ, 3 RWLD => 4 KRBG
1 XRCH => 7 GPNQ
3 WCFT => 9 DQHBG
1 FTPQ => 8 CZHTP
1 PBMR, 2 ZTKSW => 2 BNKVZ
2 PLRK, 3 CPCS => 8 ZSGBG
3 NGDX, 3 XRCH => 6 XTRQC
6 ZTKSW, 11 HNHC, 22 SNBS => 9 WNJWP
5 KQKXZ => 8 HWFQ
23 WCFT => 7 PBMR
1 LRZV, 1 QDHJT => 2 GFJW
1 ZSGBG, 5 CGTHV, 9 ZRMJ => 3 LMHL
1 DQHBG => 9 XRCH
1 GDQG, 17 RWLD, 2 KGJQ, 8 VCDW, 2 BNKVZ, 2 WNJWP, 1 VGZVD => 3 NCPSZ
19 SJLP, 3 ZTKSW, 1 CZHTP => 4 LFPRM
14 SNBS => 8 CGTHV
3 DQHBG, 4 WCFT => 1 FTPQ
3 MSKT, 3 NDJG => 5 QDHJT
''';
