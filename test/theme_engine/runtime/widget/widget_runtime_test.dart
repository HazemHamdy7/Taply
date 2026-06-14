import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/theme_engine/runtime/widget/widget_runtime.dart';

void main() {
  group('WidgetRuntime', () {
    test('createText creates TextWidgetData', () {
      final runtime = WidgetRuntime();
      final config = TextWidgetConfig(
        source: 'Hello World',
        fontSize: 16,
        color: '#000000',
      );
      final data = BusinessCardData();
      final result = runtime.createText(config, data);
      expect(result, isA<TextWidgetData>());
      expect(result.text, 'Hello World');
      expect(result.fontSize, 16);
      expect(result.color, '#000000');
    });

    test('createText with template resolves field', () {
      final runtime = WidgetRuntime();
      final config = TextWidgetConfig(source: r'${fullName}');
      final data = BusinessCardData(fullName: 'John Doe');
      final result = runtime.createText(config, data);
      expect(result.text, 'John Doe');
    });

    test('createAvatar creates AvatarWidgetData', () async {
      final runtime = WidgetRuntime();
      final config = AvatarWidgetConfig(
        source: '',
        size: 80,
        shape: 'circle',
      );
      final data = BusinessCardData();
      final result = await runtime.createAvatar(config, data);
      expect(result, isA<AvatarWidgetData>());
      expect(result.size, 80);
      expect(result.shape, 'circle');
    });

    test('createQR creates QRCodeWidgetData', () async {
      final runtime = WidgetRuntime();
      final config = QRCodeWidgetConfig(
        content: 'https://example.com',
        size: 128,
      );
      final data = BusinessCardData();
      final result = await runtime.createQRCode(config, data);
      expect(result, isA<QRCodeWidgetData>());
      expect(result.size, 128);
      expect(result.content, 'https://example.com');
    });

    test('createImage creates ImageWidgetData', () {
      final runtime = WidgetRuntime();
      final config = ImageWidgetConfig(source: 'photo.jpg', width: 200);
      final data = BusinessCardData();
      final result = runtime.createImage(config, data);
      expect(result, isA<ImageWidgetData>());
      expect(result.source, 'photo.jpg');
      expect(result.width, 200);
    });

    test('createDivider creates DividerWidgetData', () {
      final runtime = WidgetRuntime();
      final config = const DividerWidgetConfig(thickness: 2, color: '#CCCCCC');
      final result = runtime.createDivider(config);
      expect(result, isA<DividerWidgetData>());
      expect(result.thickness, 2);
      expect(result.color, '#CCCCCC');
    });

    test('createSocialIcons creates SocialIconsWidgetData', () {
      final runtime = WidgetRuntime();
      final config = SocialIconsWidgetConfig(
        icons: [
          SocialIconConfig(
            platform: 'github',
            url: 'https://github.com/johndoe',
          ),
          SocialIconConfig(
            platform: 'twitter',
            url: 'https://twitter.com/johndoe',
          ),
        ],
      );
      final data = BusinessCardData();
      final result = runtime.createSocialIcons(config, data);
      expect(result, isA<SocialIconsWidgetData>());
      expect(result.icons.length, 2);
    });

    test('createContactButtons creates ContactButtonsWidgetData', () {
      final runtime = WidgetRuntime();
      final config = ContactButtonsWidgetConfig(
        buttons: [
          ContactButtonConfig(type: 'email', value: 'john@example.com', label: 'Email'),
          ContactButtonConfig(type: 'phone', value: '+1234567890', label: 'Call'),
        ],
      );
      final data = BusinessCardData();
      final result = runtime.createContactButtons(config, data);
      expect(result, isA<ContactButtonsWidgetData>());
      expect(result.buttons.length, 2);
    });
  });
}
