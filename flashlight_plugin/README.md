# flashlight_plugin

Small Flutter plugin for toggling the device flashlight.

## Usage

Add the plugin to your app and call the static API:

```dart
await FlashlightPlugin.toggle();
await FlashlightPlugin.turnOn();
await FlashlightPlugin.turnOff();
```

## Platform support

- Android: supported through `MethodChannel` and native `CameraManager`
- iOS / web / desktop: unsupported, the app should show a warning dialog

## Demo

Run the example app inside this package to try the flashlight toggle UI.

