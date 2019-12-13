/*
--- Day 8: Space Image Format ---

The Elves' spirits are lifted when they realize you have an opportunity to
reboot one of their Mars rovers, and so they are curious if you would spend a
brief sojourn on Mars. You land your ship near the rover.

When you reach the rover, you discover that it's already in the process of
rebooting! It's just waiting for someone to enter a BIOS password. The Elf
responsible for the rover takes a picture of the password (your puzzle input)
and sends it to you via the Digital Sending Network.

Unfortunately, images sent via the Digital Sending Network aren't encoded with
any normal encoding; instead, they're encoded in a special Space Image Format.
None of the Elves seem to remember why this is the case. They send you the
instructions to decode it.

Images are sent as a series of digits that each represent the color of a single
pixel. The digits fill each row of the image left-to-right, then move downward
to the next row, filling rows top-to-bottom until every pixel of the image is
filled.

Each image actually consists of a series of identically-sized layers that are
filled in this way. So, the first digit corresponds to the top-left pixel of the
first layer, the second digit corresponds to the pixel to the right of that on
the same layer, and so on until the last digit, which corresponds to the
bottom-right pixel of the last layer.

For example, given an image 3 pixels wide and 2 pixels tall, the image data
123456789012 corresponds to the following image layers:

Layer 1: 123
         456

Layer 2: 789
         012

The image you received is 25 pixels wide and 6 pixels tall.

To make sure the image wasn't corrupted during transmission, the Elves would
like you to find the layer that contains the fewest 0 digits. On that layer,
what is the number of 1 digits multiplied by the number of 2 digits?

--- Part Two ---

Now you're ready to decode the image. The image is rendered by stacking the
layers and aligning the pixels with the same positions in each layer. The digits
indicate the color of the corresponding pixel: 0 is black, 1 is white, and 2 is
transparent.

The layers are rendered with the first layer in front and the last layer in
back. So, if a given position has a transparent pixel in the first and second
layers, a black pixel in the third layer, and a white pixel in the fourth layer,
the final image would have a black pixel at that position.

For example, given an image 2 pixels wide and 2 pixels tall, the image data
0222112222120000 corresponds to the following image layers:

Layer 1: 02
         22

Layer 2: 11
         22

Layer 3: 22
         12

Layer 4: 00
         00

Then, the full image can be found by determining the top visible pixel in each
position:

- The top-left pixel is black because the top layer is 0.
- The top-right pixel is white because the top layer is 2 (transparent), but the
  second layer is 1.
- The bottom-left pixel is white because the top two layers are 2, but the third
  layer is 1.
- The bottom-right pixel is black because the only visible pixel in that
  position is 0 (from layer 4). So, the final image looks like this:

01
10
What message is produced after decoding your image?
*/

import 'package:test/test.dart';
import 'package:quiver/iterables.dart';

class Layer {
  List<int> data;
  int width;
  int height;

  Layer(this.width, this.height, this.data);

  int countColor(int color) => data.where((d) => d == color).length;

  int colorAt(int x, int y) => data[y * width + x];
}

const $transparent = 2;
const $black = 0;

class Image {
  final List<Layer> layers;
  final int width;
  final int height;
  Image._(this.width, this.height, this.layers);
  static Image parse(String sif, int width, int height) => Image._(
      width,
      height,
      partition(sif.codeUnits, width * height)
          .map((units) => Layer(
              width, height, units.map((u) => u - '0'.codeUnitAt(0)).toList()))
          .toList());

  int colorAt(int x, int y) => layers
      .map((l) => l.colorAt(x, y))
      .firstWhere((c) => c != $transparent, orElse: () => $transparent);

  String render() {
    var sb = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        sb.write(colorAt(x, y) == $black ? ' ':  '\$');
      }
      sb.writeln();
    }
    return sb.toString();
  }
}

void main() {
  group('part1', () {
    test('task', () {
      var layer = (List.of(Image.parse(input, 25, 6).layers)
            ..sort((l1, l2) => l1.countColor(0) - l2.countColor(0)))
          .first;
      print(layer.countColor(1) * layer.countColor(2));
    });
  });

  group('part2', () {
    test('task', () {
      var image = Image.parse(input, 25, 6);
      print(image.render());
    });
  });
}

const input = '21222222222222010222122222222222222122222022220022'
    '22222222222002222002222222122220022212222020022222'
    '20202222221222222222222222222222220122202222222022'
    '22222222222222211222222222222222222022222022222022'
    '22222222222202222212222222222222222202222020222222'
    '21222222220222222222222222222222220122212222222222'
    '20222222222222000222122222222222222122222122221222'
    '22222222222212222112222222022220122212222022222222'
    '21212222220222222222222222222222221122202222222022'
    '22222222222222202222122222222222222122222222221022'
    '22222222222112222222222222022220022212222121222222'
    '21212222222222222222222222222222222222212222222122'
    '20222222222222200222122222222222222122222122222022'
    '22222222222122222122222222222220222222222020122022'
    '22202222220222222222222222222222221022212222222122'
    '21222222222222021222222222222222222122222022221222'
    '22222222222112222112222222022221122202222121122222'
    '21202222220222222222222222222222221022222222222222'
    '21222222222222221222122222222222222222222222222022'
    '22222222222212222222222222122221122222222021022122'
    '21222222220222222222222222222222222222212222222222'
    '20222222222222202222222222222222222122122122220222'
    '22222222222122222012222222022220222202222221022122'
    '22222222222222222222222222222222220022222222222222'
    '20222222222222020222222221222222222022222022222022'
    '22222222222002222202222222122222222222222121022122'
    '20222222220222222222222222222222221022222222222020'
    '22222222222222011222022220222222222022022122221122'
    '22222222222012222022222222122221022212222121022022'
    '20222222220222222222222222222212221122212222222221'
    '20222222222222221222222220222222222122122122220222'
    '22222202222212222022222222222221122202222222122022'
    '20222222222222222222222222222212220022222222222221'
    '22222222222222010222122220222222222022222222221122'
    '22222202222112222212222222022220222202222220122222'
    '20212222222222222222222222222202222122222222222020'
    '20222222222222111222222222222222222022022022221122'
    '22222202222202222012222222222221022222222122222122'
    '21222222222222222222222222222202220022222222222120'
    '22222222222222012222122222222222222022222222221022'
    '22222212222222222202222222122220222212222222222222'
    '21212222222222222222222022222222220122212222222020'
    '22222222222222101222222221222222222222122222222222'
    '22222202222202222002222222122220122202222021022222'
    '20222222220222222222222022222202222022212222222222'
    '20222222222222221222122221222222222202222022222122'
    '22222222222111222222222222022221022202222121022122'
    '22212222220222222222222122222222220222202222222120'
    '21222222222222221222022222222222222012122122221022'
    '22222220222010222102222222222220222202222220122022'
    '20212222220222222222222022222222220222212222222022'
    '22222222222222220222222221222222222212122122221122'
    '22222201222121022122222222222221222222222222022222'
    '20222222222222222222202222222212221022202222222222'
    '22222222222222211222022220222222222022222222220122'
    '22222202222212222212222222222222222202222122222022'
    '21222222220222222222202022222212221022202222222021'
    '20222222222222202222122221222222222002022122022222'
    '22222222222001222012121222022221222222222022022122'
    '22202222221222222222202122222202222222212221222220'
    '20222222222222210222022221222222222102122222220122'
    '22222211222010122022021222122222122202222222122122'
    '21202222222222222222202022222212220022222221222020'
    '21222222222220210222222220222222222112122122122222'
    '22222210221020022212120222022220122212222221122122'
    '21212222220222222222222122222212220122212220222120'
    '22222222222220020222022221202222222102222222122222'
    '22222222221020122112221222122220222222222222222222'
    '20202222222222222222202122222212121222202222222121'
    '21222222222222211222122222202222222212022220121122'
    '22222220221211222102020222022222122212222220122222'
    '22202222220222222222202222222202120022212221222222'
    '20222222222221212222022222222222222222122020221222'
    '22222210220122122212021222022221022202222120222022'
    '22212222222222222222212122222202122022212220222220'
    '20222222222220020222022221212222222202122020122022'
    '22222202220122022002121222222221122212222221222022'
    '20222222222222222222202022222212121222212221222022'
    '21222222222221122222222220222222222102122122022122'
    '22222201220110121022221222122222222222222121222022'
    '20212222222222222222202022222202121122202021222022'
    '22222222222221002222022222212222222002122122222122'
    '22222221220010020002220222222220222202222121122022'
    '21202222221222222222222122222212122222202221222222'
    '22222222222221101222222222212222222120122221121222'
    '22222200222020122002221222122221222202222120122022'
    '20202222222222222222222122222222121022222020222221'
    '20222222222222020222222222212222222211122212220022'
    '22222200220112121122121222122221022202222020222222'
    '20212222220222222222212122222202122022222221222122'
    '21222222222222122222222220222222222011022020110122'
    '22222210221202120212220222122221122212222021022222'
    '20202222220222222222222022222202222122202221222121'
    '21222222222222212222022222222222222200222221001022'
    '22222200220212122222021222222221022212222022222122'
    '21222220220222222222222022222202021122212022222021'
    '22222222222221100222122221202222222212022102220222'
    '12222221220222122022221222122220222202222121222222'
    '21202220221222222222202022222202221022212220222221'
    '22222222222222121222222122222222222012022220221122'
    '02222220221010020212021222122221022212221121122120'
    '22202222222222222222212022222202021022202022222221'
    '22222222222221121222122220202222222102122201121122'
    '02212210222202222222021222022221122212222020222021'
    '21212222221222222222202022222212222222212022222120'
    '22222222222222111222022220202222222222022222221122'
    '02222201220010220002020222122221222212221020122122'
    '21212221220222222220212022222202020222212022222122'
    '22222222222220000222022221212222222002022211020222'
    '02202220221220022022022222122221222222222022122221'
    '22212221222222222220212022222202222022212221222222'
    '20222222222221021222222022222222222220222200102222'
    '12222222221111021112221222222222222202220022122222'
    '20212221221222220221222022222202222122212120222222'
    '22222222222222202222022221212222222022222212002122'
    '02212210220012022202221222022220122212220120222020'
    '20222202222222221221222022222202220022212021222021'
    '20222222222220001222122020222222222220022112100222'
    '12212220221120122022121222122221022222221022122122'
    '21202201221222220221202222222222220122212021222221'
    '22222222222222201222122122202222202100222010211022'
    '02202211220001020112120222122222022202222222222221'
    '21212211200222220221222122222212220122222221222122'
    '21222222222220210222022022212222222110121201200222'
    '22212220221121122022120222220220022212220021222220'
    '20202202202222221220222102222222220122202120022021'
    '20222222222222200222222222222222222110020200220222'
    '12212212222000022222222222220211122202220221022020'
    '22222200201222221222212112222202121222222222122120'
    '20222222222221222222222121212222212110020120121022'
    '22202211222111222202022222121222222212220020122021'
    '21202220212222220221202122222022121222212221022022'
    '20222222222221021220022021202222212211222101222022'
    '02222222222012021112221222221211022202220222222221'
    '22222200202222222222202212222202221122222020122220'
    '20222222222222112222022122202222202011222211110022'
    '02202210220222121202121222022221022202221022122221'
    '21202200220222220222222222222021220022202120022122'
    '20222222222221012221122220202222222210022022221222'
    '02202220222111220022220222020212202222220222222121'
    '20202220200222222221222002222101120122212220022022'
    '20220222222221100222221221202222002100021001002122'
    '02222211221111221202222222120212202222222120022022'
    '22212202201222222202222022222100222122202222022122'
    '22222222222222020220121022202222212010022211021222'
    '22222221222122121102021222020201012222220221022021'
    '22202201211222222212202101222200221022202122122120'
    '21220222222222022220021222212222202001120210021220'
    '12202210220122122022020222222212112222222221222020'
    '21202202220222220211222212222200221022222222122021'
    '20222222222220211221020220202222102021121212012121'
    '02202221222100220112122222222222102212222022222222'
    '22202200220222220210212110222002122022212221222222'
    '22222222222222001220112221202222022201122201011222'
    '12212202221201020102022222122200102222222222222020'
    '20212220200222222210222221222002120222212220122021'
    '21221222222220002222220120212222002221220202002120'
    '22202222222212221122121222221220022202220221222022'
    '21212211220222220212222022222100122022222220222022'
    '20220222222222111220202120222222012012020100012122'
    '12202202222120022022120222220220122222221121122220'
    '21212211222222212220222200022102022122202021122022'
    '21221222222222200220100121212222122002022222002122'
    '02202222222222220012121222021222012222222020122021'
    '21212212222222222221222212122211220122222220122022'
    '20222222222221110222010021222222222000020021211221'
    '12222202220200222122220222222222202222221022022121'
    '21202201221222212211222101022202020022202221122021'
    '21220222222221010222221121202222112120221210221021'
    '22212200222100022022022222022220002212222020022221'
    '21202200201222212221222022022201122222212222222122'
    '22222222222222221221121022222222212212221022120121'
    '22222201220112121122120222120202122212221222122022'
    '21212201222222202202222212022211122222212221022120'
    '22221222222222001220021022212222022200021200212120'
    '12212220220110221002222222120222222222220020122020'
    '21212201221222210211212111222201220122212222122022'
    '20222222222222211222222220222222002200122100000021'
    '12222212221201022002220222022202202222221122022122'
    '21212210221222201200222112021120220122202020222122'
    '22221222222222110222212122222222202001122200121222'
    '02212200222022020002021222121222012202220021022220'
    '22212220210222212222212012122012020022222021122121'
    '21222222222222212221101021202222202021020200112020'
    '12212220222221122202120222221201112222220222022022'
    '22212200222222220201202120120221022122222022022020'
    '20222222222222012222120022202222212101121221022221'
    '12202221221220122212220222020221012202220022222022'
    '20212220220222200211212221020211020222202122122221'
    '21220222222220000222002020222222022202120110200021'
    '22202211220010021222222222022222122212221220122222'
    '21222200221222201210222022221110022022202121022120'
    '22222222222220022220122021202222012010021211201021'
    '22202211221020020112022222121201102202220122222222'
    '20222210222222202201212001120210022222222120222020'
    '22220222222222200221000021212222112202220101112021'
    '12202200222001121012121222122202022212222222222220'
    '21222221210222221221222002122221120022222122022121'
    '21220222202220000222201120212222002211021221100221'
    '02202200221200122212222222021201002212221220022221'
    '20212201200222200222222100001022222122202122122222'
    '21221222002220102220210221212222102200022011210222'
    '12222211222021022112220222021221102222221022122221'
    '20212202221222211221202200022112220122222220222021'
    '22221222212220210220120221202222122010222120122222'
    '02222211221001221022022222122200102212222220222122'
    '21202211212222220210222211100110221222222121122020'
    '20222222212220212220120222202222202212021211022221'
    '22212220221220021012020222221212112212221221222021'
    '22222220200222202211222021210100221122212222222220'
    '21222222002222012221012220222222122102220200222120'
    '12002210220201121012222222220221102202222021122022'
    '20202222202222200202222210001001121222202022022220'
    '21220222012220100222002122202222222201221201000021'
    '02222200220010121212120222221201102212221121122022'
    '20222210201222200221202000222200021122212022122020'
    '21222222112220110222001122222222202120021202100121'
    '02112211221202021112221222221221102202202020222222'
    '20202201222222201211202112222201021122212021222001'
    '22222222012222122220220120212222202222122222011120'
    '22002202220000220222221222221200022202221022122020'
    '22222200202222221210102112202011121122202020022222'
    '20222222122222102221212120202222022021120110112222'
    '02002220222212221102221222021221012202200222222222'
    '21212210202222200211012122201122220122202222022201'
    '21222222002222001022021020212222212112122012102122'
    '10212211222202122202222222121220212222212010022021'
    '20212212200022202210222101100220122022212121122022'
    '20222222022221102220201020202222012010020120021020'
    '21012211220021220202022202221211012202222221222021'
    '10222220200022201202002210222012022122202222222200'
    '21220222202220201121020020202222222112220000010120'
    '10222212221122022122222202020210022222200110022220'
    '10202220220122200220012112212010120222202122222102'
    '20220222122222010121221221212222002002022111220020'
    '10122221221111021022020202020212022211201001222120'
    '11222201200122221202112110122202221022212221222121'
    '12220222022220120121102122222222002010221002022122'
    '20002211220210220222121212121202212221210221222120'
    '22212110212222210200102112212020121022212022022020'
    '20222222202221010020210221222222222101220000010021'
    '22222220221200120202022202021220102221200121222120'
    '22222120200022200222102210211101020022222022222011'
    '22221222002221221020120022222222102120020120202120'
    '00202202220220022102120022021212212210200000220222'
    '22202220220222201212122100102200022122222020022220'
    '10222222012221000020102022022222212220122001012121'
    '22122210221021021022021102221221202212202000120221'
    '11212022202022201201022220202100122022212122222222'
    '21220222112221202221010120212222222121221202220120'
    '22102212222010120122121002220201222201221120221020'
    '11212202212022211200010200202121121022222121122111'
    '10222222012220221022221122002222022222121221221220'
    '11012110220000020222021012010200012201202000020021'
    '21202211211222212200222110110222020022202020222222'
    '00221222212221222212212120002222112100000221222020'
    '11222021220201020012022002020201102100220000020121'
    '22222212220022212210110020001100122122222222122101'
    '01220222102220011211110120002022012102201112101021'
    '01122011221212221112021222121210002121200020222020'
    '02212010220022211210020012122002121122212022022011'
    '22220222102221211020120120002122212120120021112022'
    '10112200221010020212221202220211022222201212121220'
    '12222202222222222222012011221000022222202121122111'
    '21222222112220222210112221002222212110120002001121'
    '01212202221021120012120022022221102000201211221222'
    '01222220201022210210222000101020222022222120022022'
    '20222222112221022122210222202122102120220022011120'
    '12002000220022020022121202021212000201222012022020'
    '12212100220222200220120122112111121022222222122011'
    '11221222002220222012110022022122222201212212020121'
    '12122211221001021120020012211211100121200110020021'
    '02222221201122220200101011121000122022202122120221'
    '10221222022222222101202120002222002112102102212221'
    '20122111020221020102220102212200102221202020021221'
    '00212212202122202220011000010102222022202221221011'
    '02220222012222211210020120122122022120001020120221'
    '12222102021222220100010012112202021000201012022022'
    '11112112210122210101200121110022021022112222221120'
    '11222222002220012011202221122022212101001111201122'
    '01102200120212021200000202102222111120212121121121'
    '01112101200122210000222102010121220122122221122101'
    '20222122102222211022210022112122112200222020222121'
    '01212122021202021120020212112011012101201222020120'
    '02222200220222200221202211100101120122212120120211'
    '20220122002221012122022220102122102021020121012021'
    '02002212021011220000000202112121200011202122121220'
    '10202220220122211002212020110221221222102021021210'
    '11220022222222211221200220212222122122002210110120'
    '02002110021200022011221222012202022012202121220022'
    '12022221202222222120201100210221121222212122122212'
    '02221122222220110110202220122222002000100111100020'
    '10022210022102221201002122101000112222221210122120'
    '22022010222022220002022021120122021222012020121120'
    '20220022212220202022200221002222122212112011222221'
    '12102112022210220100120022102110122221221000122021'
    '01012101210022222001120022201222120022222220212010'
    '21102200210112202112001102011010020121212011100101'
    '21210221200210012000012101202011120222121021111002'
    '10020221011201001201222212211020210000121202201011';
