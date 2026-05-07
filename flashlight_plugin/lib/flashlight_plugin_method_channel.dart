import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flashlight_plugin_platform_interface.dart';

class MethodChannelFlashlightPlugin extends FlashlightPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flashlight_plugin');

  @override
  Future<bool> toggle() {
    return _invokeBool('toggleFlashlight');
  }

  @override
  Future<bool> turnOn() {
    return _invokeBool('turnOnFlashlight');
  }

  @override
  Future<bool> turnOff() {
    return _invokeBool('turnOffFlashlight');
  }

  @override
  Future<bool> isOn() {
    return _invokeBool('isFlashlightOn');
  }

  @override
  Future<bool> isSupported() {
    return _invokeBool('isFlashlightSupported');
  }

  Future<bool> _invokeBool(String method) async {
    final value = await methodChannel.invokeMethod<bool>(method);
    return value ?? false;
  }
}
