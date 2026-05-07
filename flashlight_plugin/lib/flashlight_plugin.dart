import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');

  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<bool> toggle() {
    return _invokeSupported('toggleFlashlight');
  }

  static Future<bool> turnOn() {
    return _invokeSupported('turnOnFlashlight');
  }

  static Future<bool> turnOff() {
    return _invokeSupported('turnOffFlashlight');
  }

  static Future<bool> isOn() {
    return _invokeSupported('isFlashlightOn');
  }

  static Future<bool> _invokeSupported(String method) async {
    if (!isSupported) {
      throw UnsupportedError(
        'Flashlight is supported only on Android for this lab.',
      );
    }
    final value = await _channel.invokeMethod<bool>(method);
    return value ?? false;
  }
}
