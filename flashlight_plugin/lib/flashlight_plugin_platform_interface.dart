import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flashlight_plugin_method_channel.dart';

abstract class FlashlightPluginPlatform extends PlatformInterface {
  /// Constructs a FlashlightPluginPlatform.
  FlashlightPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlashlightPluginPlatform _instance = MethodChannelFlashlightPlugin();

  static FlashlightPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlashlightPluginPlatform] when
  /// they register themselves.
  static set instance(FlashlightPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> toggle();

  Future<bool> turnOn();

  Future<bool> turnOff();

  Future<bool> isOn();

  Future<bool> isSupported() async => true;
}
