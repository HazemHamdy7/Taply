import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/runtime/runtime.dart';

void main() {
  group('CardRuntime', () {
    test('setCardData stores business card data', () {
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(
        fullName: 'Test User',
        email: 'test@example.com',
      ));
      expect(runtime.dataProvider.resolve('fullName'), 'Test User');
    });

    test('setDocument sets the theme document', () {
      final runtime = CardRuntime();
      runtime.setDocument(ThemeDocument(
        metadata: ThemeMetadata(id: 'test', name: 'test'),
        canvas: ThemeCanvas(width: 300, height: 200),
      ));
      expect(runtime.hasDocument, isTrue);
    });

    test('hasData returns false before setCardData', () {
      final runtime = CardRuntime();
      expect(runtime.hasData, isFalse);
    });

    test('hasData returns true after setCardData', () {
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(fullName: 'Jane'));
      expect(runtime.hasData, isTrue);
    });

    test('hasDocument returns false before setDocument', () {
      final runtime = CardRuntime();
      expect(runtime.hasDocument, isFalse);
    });

    test('dataProvider resolve works after setCardData', () {
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(fullName: 'Card 1'));
      expect(runtime.dataProvider.resolve('fullName'), 'Card 1');

      runtime.setCardData(BusinessCardData(fullName: 'Card 2'));
      expect(runtime.dataProvider.resolve('fullName'), 'Card 2');
    });
  });
}
