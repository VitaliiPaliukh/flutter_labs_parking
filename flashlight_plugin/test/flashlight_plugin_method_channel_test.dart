import 'package:flashlight_plugin/flashlight_plugin_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelFlashlightPlugin();
  const channel = MethodChannel('flashlight_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'toggleFlashlight':
            case 'turnOnFlashlight':
              return true;
            case 'turnOffFlashlight':
              return false;
            case 'isFlashlightOn':
              return true;
            case 'isFlashlightSupported':
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('toggle and state queries use the method channel', () async {
    expect(await platform.toggle(), isTrue);
    expect(await platform.turnOn(), isTrue);
    expect(await platform.turnOff(), isFalse);
    expect(await platform.isOn(), isTrue);
    expect(await platform.isSupported(), isTrue);
  });
}
