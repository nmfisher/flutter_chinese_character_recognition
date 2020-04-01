import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chinese_character_recognition/chinese_character_recognition.dart';

void main() {
  const MethodChannel channel = MethodChannel('chinese_character_recognition');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ChineseCharacterRecognition.platformVersion, '42');
  });
}
