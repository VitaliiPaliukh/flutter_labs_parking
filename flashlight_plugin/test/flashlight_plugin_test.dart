import 'package:flashlight_plugin/flashlight_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flashlight_plugin');
  final previousTarget = debugDefaultTargetPlatformOverride;
  bool isOn = false;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    isOn = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case 'toggleFlashlight':
          isOn = !isOn;
          return isOn;
        case 'turnOnFlashlight':
          isOn = true;
          return isOn;
        case 'turnOffFlashlight':
          isOn = false;
          return isOn;
        case 'isFlashlightOn':
          return isOn;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = previousTarget;
  });

  test('toggle changes the flashlight state', () async {
    expect(await FlashlightPlugin.toggle(), isTrue);
    expect(await FlashlightPlugin.isOn(), isTrue);
    expect(await FlashlightPlugin.toggle(), isFalse);
  });

  test('turnOn and turnOff work', () async {
    expect(await FlashlightPlugin.turnOn(), isTrue);
    expect(await FlashlightPlugin.turnOff(), isFalse);
  });
}
