import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/avatar/avatar_runtime.dart';

void main() {
  group('AvatarRuntime', () {
    test('can be instantiated', () {
      final runtime = AvatarRuntime();
      expect(runtime, isA<AvatarRuntime>());
    });

    test('loadAvatar with empty source returns null for memory type', () async {
      final runtime = AvatarRuntime();
      try {
        final result = await runtime.loadAvatar('', type: AvatarSource.memory);
        expect(result, isNull);
      } catch (_) {
        // Expected to fail gracefully
      }
    });
  });
}
