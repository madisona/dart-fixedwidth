import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('Padding Tests', () {
    test('Float padding pads to the left with appropriate decimals ', () {

      expect(floatPadding(6, 10, fractionalDigits: 0), equals("000010"));
      expect(floatPadding(6, 10, fractionalDigits: 2), equals("010.00"));
      expect(floatPadding(6, 10.1234, fractionalDigits: 2), equals("010.12"));
      expect(floatPadding(8, 300.1234, fractionalDigits: 2), equals("00300.12"));
      expect(floatPadding(8, 300.1234, fractionalDigits: 2), equals("00300.12"));
      expect(floatPadding(8, 125.1254, fractionalDigits: 2), equals("00125.13"));
      expect(floatPadding(10, 25.1234, fractionalDigits: 3), equals("000025.123"));
    });
  });
}
